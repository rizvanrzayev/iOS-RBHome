import Foundation
import SwiftUI
import RBDesignSystem
import RBHomeDomain

@MainActor
package final class HomeCardSegmentViewModel: ObservableObject {
    @Published var cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel> = .loading
    @Published var bonusSectionState: RBHomeFlowSectionState<RBHomeFlowCardBonusSection> = .loading
    @Published var panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel> = .loading

    private var cards: [HomeCard] = []
    private var selectedCardIdn: Int?
    private var selectedCardToken: String?
    private var bonusPerCard: [Int: HomeCardBonusPoint] = [:]
    private var rawTransactions: [HomeCardTransaction] = []
    private var panelSearchText: String = ""
    private var panelDateFilter: RBHomeFlowPanelFilter? = nil

    private let fetchCardsUseCase: FetchCardsUseCase
    private let fetchTransactionsUseCase: FetchCardTransactionsUseCase
    private let fetchBonusUseCase: FetchCardBonusUseCase
    private let fetchEDVBalanceUseCase: FetchEDVBalanceUseCase
    private let setFavoriteCardUseCase: SetFavoriteCardUseCase
    private let onCardToCardTap: (Int) -> Void
    private let onTopupTap: (Int) -> Void
    private let onCardApplePayTap: (Int, String, Int) -> Void
    private let onCardDigitalSkinTap: (Int, String, Int) -> Void
    private let onCardRemoveTap: (String) -> Void
    private let onDecryptCardPAN: (String) -> String?
    private let onFetchCardCVV: (Int, @escaping (Result<String, Error>) -> Void) -> Void
    private let onBonusTap: (Int, String, String) -> Void
    private let onEDVTap: () -> Void
    private let onPaymentsTap: (String) -> Void
    private let onCreditCardPaymentTap: (String) -> Void
    private let onInstallmentStatementTap: (Int) -> Void
    private let onCardBlockToggleTap: (Int, Bool) -> Void
    private let onCardLimitManagementTap: (Int, String) -> Void
    private let onCardRequisitesTap: (String, String) -> Void
    private let onCardDocumentsTap: () -> Void
    private let onCardDetailSectionTap: (HomeCardDetailSectionContext) -> Void
    private let onSplitBillTap: (HomeCardTransactionActionPayload) -> Void
    private let onChargebackTap: (HomeCardTransactionActionPayload) -> Void

    private var edvBalance: HomeEDVBalance?

    package init(
        fetchCardsUseCase: FetchCardsUseCase,
        fetchTransactionsUseCase: FetchCardTransactionsUseCase,
        fetchBonusUseCase: FetchCardBonusUseCase,
        fetchEDVBalanceUseCase: FetchEDVBalanceUseCase,
        setFavoriteCardUseCase: SetFavoriteCardUseCase,
        onCardToCardTap: @escaping (Int) -> Void = { _ in },
        onTopupTap: @escaping (Int) -> Void = { _ in },
        onCardApplePayTap: @escaping (Int, String, Int) -> Void = { _, _, _ in },
        onCardDigitalSkinTap: @escaping (Int, String, Int) -> Void = { _, _, _ in },
        onCardRemoveTap: @escaping (String) -> Void = { _ in },
        onDecryptCardPAN: @escaping (String) -> String? = { _ in nil },
        onFetchCardCVV: @escaping (Int, @escaping (Result<String, Error>) -> Void) -> Void = { _, completion in
            completion(.failure(NSError(domain: "RBHome", code: -1, userInfo: [NSLocalizedDescriptionKey: "CVV əldə olunmadı"])))
        },
        onBonusTap: @escaping (Int, String, String) -> Void = { _, _, _ in },
        onEDVTap: @escaping () -> Void = {},
        onPaymentsTap: @escaping (String) -> Void = { _ in },
        onCreditCardPaymentTap: @escaping (String) -> Void = { _ in },
        onInstallmentStatementTap: @escaping (Int) -> Void = { _ in },
        onCardBlockToggleTap: @escaping (Int, Bool) -> Void = { _, _ in },
        onCardLimitManagementTap: @escaping (Int, String) -> Void = { _, _ in },
        onCardRequisitesTap: @escaping (String, String) -> Void = { _, _ in },
        onCardDocumentsTap: @escaping () -> Void = {},
        onCardDetailSectionTap: @escaping (HomeCardDetailSectionContext) -> Void = { _ in },
        onSplitBillTap: @escaping (HomeCardTransactionActionPayload) -> Void = { _ in },
        onChargebackTap: @escaping (HomeCardTransactionActionPayload) -> Void = { _ in }
    ) {
        self.fetchCardsUseCase = fetchCardsUseCase
        self.fetchTransactionsUseCase = fetchTransactionsUseCase
        self.fetchBonusUseCase = fetchBonusUseCase
        self.fetchEDVBalanceUseCase = fetchEDVBalanceUseCase
        self.setFavoriteCardUseCase = setFavoriteCardUseCase
        self.onCardToCardTap = onCardToCardTap
        self.onTopupTap = onTopupTap
        self.onCardApplePayTap = onCardApplePayTap
        self.onCardDigitalSkinTap = onCardDigitalSkinTap
        self.onCardRemoveTap = onCardRemoveTap
        self.onDecryptCardPAN = onDecryptCardPAN
        self.onFetchCardCVV = onFetchCardCVV
        self.onBonusTap = onBonusTap
        self.onEDVTap = onEDVTap
        self.onPaymentsTap = onPaymentsTap
        self.onCreditCardPaymentTap = onCreditCardPaymentTap
        self.onInstallmentStatementTap = onInstallmentStatementTap
        self.onCardBlockToggleTap = onCardBlockToggleTap
        self.onCardLimitManagementTap = onCardLimitManagementTap
        self.onCardRequisitesTap = onCardRequisitesTap
        self.onCardDocumentsTap = onCardDocumentsTap
        self.onCardDetailSectionTap = onCardDetailSectionTap
        self.onSplitBillTap = onSplitBillTap
        self.onChargebackTap = onChargebackTap
    }

    func load() async {
        cardsState = .loading
        bonusSectionState = .loading
        panelState = .loading

        async let edvResult = fetchEDVBalanceUseCase.execute()

        do {
            edvBalance = try? await edvResult
            let fetched = try await fetchCardsUseCase.execute()
            cards = fetched

            if fetched.isEmpty {
                cardsState = .empty(title: "Kart yoxdur", message: nil)
                bonusSectionState = .loaded(.edvOnly(edvPlaceholderModel))
                panelState = .empty(title: "Əməliyyat yoxdur", message: nil)
            } else {
                cardsState = .loaded(makeCarousel(from: fetched))
                if let first = fetched.first {
                    selectCard(first)
                    if let token = first.token, first.cardType == .stored {
                        await loadStoredCardDetails(token: token)
                    } else {
                        await loadCardDetails(cardIdn: first.cardIdn)
                    }
                } else {
                    bonusSectionState = .loaded(.edvOnly(edvPlaceholderModel))
                    panelState = .empty(title: "Əməliyyat yoxdur", message: nil)
                }
            }
        } catch {
            cardsState = .error(title: "Xəta", message: error.localizedDescription)
            bonusSectionState = .error(title: "Xəta", message: nil)
            panelState = .error(title: "Xəta", message: nil)
        }
    }

    func onCardSelected(cardId: String) async {
        let selected = cards.first { String($0.cardIdn) == cardId || $0.token == cardId }
        guard let selected else { return }
        let selectedKey = selected.token ?? String(selected.cardIdn)
        guard selectedKey != currentSelectedCardKey else { return }

        if selected.cardType == .stored {
            selectCard(selected)
            bonusSectionState = .loaded(.edvOnly(edvPlaceholderModel))
            panelState = .loading
            if let token = selected.token {
                await loadStoredCardDetails(token: token)
            } else {
                panelState = .empty(title: "Əməliyyat yoxdur", message: nil)
            }
            return
        }

        selectCard(selected)
        bonusSectionState = .loading
        panelState = .loading
        await loadCardDetails(cardIdn: selected.cardIdn)
    }

    private func loadCardDetails(cardIdn: Int) async {
        async let bonusResult = fetchBonusUseCase.execute(cardIdn: cardIdn)
        async let transResult = fetchTransactionsUseCase.execute(cardIdn: cardIdn)

        do {
            let (bonus, transactions) = try await (bonusResult, transResult)
            bonusPerCard[cardIdn] = bonus
            bonusSectionState = .loaded(makeBonusSection(from: bonus))
            rawTransactions = transactions
            panelSearchText = ""
            panelDateFilter = nil
            rebuildCarousel()
            rebuildPanel()
        } catch {
            bonusSectionState = .error(title: "Xəta", message: error.localizedDescription)
            panelState = .error(title: "Xəta", message: error.localizedDescription)
        }
    }

    private func loadStoredCardDetails(token: String) async {
        do {
            bonusSectionState = .loaded(.edvOnly(edvPlaceholderModel))
            let transactions = try await fetchTransactionsUseCase.execute(token: token)
            rawTransactions = transactions
            panelSearchText = ""
            panelDateFilter = nil
            rebuildCarousel()
            rebuildPanel()
            if transactions.isEmpty {
                panelState = .empty(title: "Əməliyyat yoxdur", message: nil)
            }
        } catch {
            panelState = .error(title: "Xəta", message: error.localizedDescription)
        }
    }

    private func rebuildCarousel() {
        cardsState = .loaded(makeCarousel(from: cards))
    }

    private func rebuildPanel() {
        panelState = .loaded(makePanel(from: filteredTransactions()))
    }

    private func filteredTransactions() -> [HomeCardTransaction] {
        var list = rawTransactions
        if !panelSearchText.isEmpty {
            list = list.filter { $0.title.localizedCaseInsensitiveContains(panelSearchText) }
        }
        if let filter = panelDateFilter {
            let range = filter.dateRange
            list = list.filter { $0.localDate >= range.from && $0.localDate <= range.to }
        }
        return list
    }

    // MARK: - Computed UI Models

    var homeModel: RBHomeFlowCardHomeModel {
        let qaState: RBHomeFlowSectionState<RBHomeFlowQuickActionsModel>
        if case .loading = cardsState { qaState = .loading } else { qaState = .loaded(homeQuickActions) }
        return RBHomeFlowCardHomeModel(
            cardsState: cardsState,
            quickActionsState: qaState,
            bonusSectionState: bonusSectionState,
            panelState: panelState
        )
    }

    var detailModel: RBHomeFlowCardDetailModel {
        let title = selectedCard?.name ?? "Kart"
        let qaState: RBHomeFlowSectionState<RBHomeFlowQuickActionsModel>
        if case .loading = cardsState { qaState = .loading } else { qaState = .loaded(detailQuickActions) }
        return RBHomeFlowCardDetailModel(
            title: title,
            cardsState: cardsState,
            quickActionsState: qaState,
            actionsState: .loaded(cardServiceActions)
        )
    }

    private var selectedCard: HomeCard? {
        if let selectedCardToken {
            return cards.first { $0.token == selectedCardToken }
        }
        if let selectedCardIdn {
            return cards.first { $0.cardIdn == selectedCardIdn }
        }
        return cards.first
    }

    private var currentSelectedCardKey: String? {
        selectedCardToken ?? selectedCardIdn.map(String.init)
    }

    private func selectCard(_ card: HomeCard) {
        selectedCardIdn = card.cardType == .stored ? nil : card.cardIdn
        selectedCardToken = card.token
    }

    private func paymentSource(for card: HomeCard?) -> String {
        guard let card else { return "" }
        if card.cardType == .stored {
            return card.token ?? ""
        }
        return card.iban ?? ""
    }

    private func handleCardToCardTap() {
        guard let card = selectedCard, card.cardType != .stored else { return }
        onCardToCardTap(card.cardIdn)
    }

    private func handleTopupTap() {
        guard let card = selectedCard, card.cardType != .stored else { return }
        onTopupTap(card.cardIdn)
    }

    private func handleCreditCardPaymentTap() {
        onCreditCardPaymentTap(paymentSource(for: selectedCard))
    }

    private func handleInstallmentStatementTap() {
        guard let card = selectedCard, card.cardType != .stored else { return }
        onInstallmentStatementTap(card.cardIdn)
    }

    private func handleBonusTap() {
        guard let card = selectedCard, card.cardType != .stored, card.cardIdn > 0 else { return }
        onBonusTap(card.cardIdn, card.name, card.currency)
    }

    private func handleEDVTap() {
        onEDVTap()
    }

    private func handleCardBlockToggleTap() {
        guard let card = selectedCard, card.cardType != .stored else { return }
        onCardBlockToggleTap(card.cardIdn, card.isLocked)
    }

    private func handleCardLimitManagementTap() {
        guard let card = selectedCard, card.cardType != .stored else { return }
        onCardLimitManagementTap(card.cardIdn, card.currency)
    }

    private func handleCardRequisitesTap() {
        guard let card = selectedCard, card.cardType != .stored, let iban = card.iban, iban.isEmpty == false else { return }
        onCardRequisitesTap(iban, card.currency)
    }

    private func handleCardDocumentsTap() {
        guard let card = selectedCard, card.cardType != .stored else { return }
        onCardDocumentsTap()
    }

    private func handleCardDetailSectionTap(sectionID: Int) {
        guard let card = selectedCard else { return }
        onCardDetailSectionTap(
            HomeCardDetailSectionContext(
                sectionID: sectionID,
                cardIdn: card.cardIdn,
                cardName: card.name,
                maskedPan: card.maskedPan,
                currency: card.currency,
                iban: card.iban,
                isLocked: card.isLocked,
                isRecharge: card.cardType == .stored,
                cardType: card.cardType,
                cardDetectionTypeRaw: cardDetectionTypeRaw(for: card),
                token: card.token,
                isJunior: card.isJunior,
                isInstallmentCard: card.installmentCard,
                isAdvanceLoan: card.isAdvanceLoan,
                hasTurnover: card.hasTurnover
            )
        )
    }

    private func handleCardApplePayTap() {
        guard let card = selectedCard, card.cardType != .stored else { return }
        onCardApplePayTap(card.cardIdn, card.maskedPan, cardDetectionTypeRaw(for: card))
    }

    private func handleCardDigitalSkinTap() {
        guard let card = selectedCard, card.cardType != .stored else { return }
        onCardDigitalSkinTap(card.cardIdn, card.maskedPan, cardDetectionTypeRaw(for: card))
    }

    private func handleCardRemoveTap() {
        guard let card = selectedCard, card.cardType == .stored, let token = card.token, token.isEmpty == false else { return }
        onCardRemoveTap(token)
    }

    // MARK: - Mappers

    private func makeCarousel(from cards: [HomeCard]) -> RBHomeFlowCarouselModel {
        RBHomeFlowCarouselModel(items: cards.map { card in
            let id = card.token ?? String(card.cardIdn)
            let amount = card.cardType == .stored ? "" : HomeAmountFormatter.format(card.amount, currency: card.currency)
            let bottomLeadingLabel = cardLabel(for: card)
            return RBHomeFlowCarouselItem(
                id: id,
                title: card.name,
                subtitle: card.maskedPan,
                amount: amount,
                networkAsset: card.cardNetwork.assetName,
                bottomLeadingLabel: bottomLeadingLabel,
                isStored: card.cardType == .stored,
                isFavorite: card.isFavorite,
                isLocked: card.isLocked,
                detailBadgeText: bottomLeadingLabel,
                cardDetailContent: makeCardDetailContent(for: card, amount: amount)
            )
        })
    }

    private func makeCardDetailContent(for card: HomeCard, amount: String) -> RBHomeFlowCardDetailContent {
        let panValue = resolvedFullPAN(for: card) ?? card.maskedPan
        let expiryText = formattedExpiry(card.expiryDate)

        return RBHomeFlowCardDetailContent(
            backgroundAssetName: detailBackgroundAssetName(for: card),
            networkAssetName: detailNetworkAssetName(for: card),
            cardName: card.name,
            amountText: amount,
            panText: panValue,
            panCopyValue: panValue.isEmpty ? nil : panValue,
            expiryText: expiryText,
            bankLogoURL: nonEmptyString(card.bankLogoURL),
            isRecharge: card.cardType == .stored,
            isLocked: card.isLocked,
            onFetchCVV: card.cardType == .stored ? nil : { [weak self] completion in
                guard let self else {
                    completion(.failure(NSError(domain: "RBHome", code: -1, userInfo: [NSLocalizedDescriptionKey: "CVV əldə olunmadı"])))
                    return
                }
                self.onFetchCardCVV(card.cardIdn, completion)
            }
        )
    }

    private func cardLabel(for card: HomeCard) -> String? {
        guard card.cardType != .stored else { return nil }
        let currency = card.currency
        if card.installmentCard, let monthly = card.monthlyDebt, monthly > 0 {
            return "Aylıq ödəniş: \(HomeAmountFormatter.format(monthly, currency: currency))"
        }
        if card.cardType == .credit, let minPay = card.minimumPayment, minPay > 0 {
            return "Min ödəniş: \(HomeAmountFormatter.format(minPay, currency: currency))"
        }
        if let interest = card.interestAmount, interest > 0 {
            return "Faiz: \(HomeAmountFormatter.format(interest, currency: currency))"
        }
        return nil
    }

    private func cardDetectionTypeRaw(for card: HomeCard) -> Int {
        switch card.cardNetwork {
        case .maestro: return 0
        case .mastercard: return 1
        case .visa: return 2
        case .discover: return 4
        case .none: return 5
        }
    }

    private func detailBackgroundAssetName(for card: HomeCard) -> String {
        guard card.cardType != .stored else { return "otherBankCard" }

        switch card.cardProductRaw {
        case "GamerCard":
            return "gamerCard"
        case "KartmaneJunior":
            return card.isPremium ? "junior-premium-bg" : "junior-bg"
        default:
            return card.isPremium ? "premiumCard" : "defaultCard"
        }
    }

    private func detailNetworkAssetName(for card: HomeCard) -> String? {
        switch card.cardNetwork {
        case .maestro:
            return "maestro"
        case .mastercard:
            return "mastercard"
        case .visa:
            return "visaWhite"
        case .discover:
            return "discoverCard"
        case .none:
            return nil
        }
    }

    private func formattedExpiry(_ rawValue: String?) -> String {
        guard let rawValue, rawValue.isEmpty == false else { return "" }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        guard let date = formatter.date(from: rawValue) else { return rawValue }
        formatter.dateFormat = "MM/yy"
        return formatter.string(from: date)
    }

    private func resolvedFullPAN(for card: HomeCard) -> String? {
        if let fullPan = nonEmptyString(card.fullPan) {
            return formattedPAN(fullPan)
        }

        guard let encryptedPan = nonEmptyString(card.encryptedPan) else { return nil }
        return onDecryptCardPAN(encryptedPan)
    }

    private func formattedPAN(_ value: String) -> String {
        value
            .replacingOccurrences(of: " ", with: "")
            .chunked(into: 4)
            .joined(separator: " ")
    }

    private func nonEmptyString(_ value: String?) -> String? {
        guard let value, value.isEmpty == false else { return nil }
        return value
    }

    private func makeBonusSection(from bonus: HomeCardBonusPoint) -> RBHomeFlowCardBonusSection {
        let edv = edvBalance
        let edvContent: RBStatCardContent
        if let edv, edv.balance > 0 || edv.pendingBalance > 0 {
            edvContent = .data(
                amount: HomeAmountFormatter.format(edv.balance, currency: "AZN"),
                detail: "Gözlənilən: \(HomeAmountFormatter.format(edv.pendingBalance, currency: "AZN"))"
            )
        } else {
            edvContent = .placeholder(subtitle: "Hesabınızı aktivləşdirin və ya qeydiyyatdan keçin")
        }

        let edvModel = RBHomeFlowEDVRefundModel(
            icon: .iconEdv,
            title: "ƏDV geri al",
            titleColor: Color.rb.edvBlue,
            content: edvContent,
            onTap: { [weak self] in
                self?.handleEDVTap()
            }
        )

        guard bonus.totalPoint > 0 else {
            return .edvOnly(edvModel)
        }

        let bonusModel = RBHomeFlowEDVRefundModel(
            icon: .iconBonus,
            title: "Bonuslarım",
            titleColor: Color.rb.green,
            content: .data(
                amount: "\(Int(bonus.totalPoint)) xal",
                detail: "Gözlənilən: \(Int(bonus.currentPoint)) xal"
            ),
            onTap: { [weak self] in
                self?.handleBonusTap()
            }
        )

        return .pair(RBHomeFlowRefundPairModel(leading: bonusModel, trailing: edvModel))
    }

    private var edvPlaceholderModel: RBHomeFlowEDVRefundModel {
        RBHomeFlowEDVRefundModel(
            icon: .iconEdv,
            title: "ƏDV geri al",
            titleColor: Color.rb.edvBlue,
            content: .placeholder(subtitle: "Hesabınızı aktivləşdirin və ya qeydiyyatdan keçin"),
            onTap: { [weak self] in
                self?.handleEDVTap()
            }
        )
    }

    private func makePanel(from transactions: [HomeCardTransaction]) -> RBHomeFlowPanelModel {
        RBHomeFlowPanelModel(
            title: "Son əməliyyatlar",
            items: transactions.prefix(20).enumerated().map { index, tx in
                let sign = tx.isCredit ? "+" : "-"
                return RBHomeFlowPanelItem(
                    id: "tx-\(index)",
                    date: HomeAmountFormatter.formatDate(tx.localDate),
                    title: tx.title,
                    subtitle: tx.subtitle,
                    amount: "\(sign)\(HomeAmountFormatter.format(tx.amount, currency: tx.currency))",
                    isCredit: tx.isCredit,
                    iconURL: tx.iconURL,
                    iconColorHex: tx.iconColorHex,
                    swipeActions: makeSwipeActions(for: tx)
                )
            },
            onSearchChange: { [weak self] text in
                self?.panelSearchText = text
                self?.rebuildPanel()
            },
            onFilterChange: { [weak self] filter in
                self?.panelDateFilter = filter
                self?.rebuildPanel()
            }
        )
    }

    private func makeSwipeActions(for transaction: HomeCardTransaction) -> [RBHomeFlowPanelSwipeAction] {
        var actions: [RBHomeFlowPanelSwipeAction] = []
        let payload = patchedActionPayload(for: transaction)

        if transaction.enableForSplit {
            actions.append(
                RBHomeFlowPanelSwipeAction(id: "\(transaction.localDate.timeIntervalSince1970)-split", kind: .splitBill) { [onSplitBillTap] in
                    onSplitBillTap(payload)
                }
            )
        }

        if transaction.enableForChargeback {
            actions.append(
                RBHomeFlowPanelSwipeAction(id: "\(transaction.localDate.timeIntervalSince1970)-chargeback", kind: .chargeback) { [onChargebackTap] in
                    onChargebackTap(payload)
                }
            )
        }

        return actions
    }

    private func patchedActionPayload(for transaction: HomeCardTransaction) -> HomeCardTransactionActionPayload {
        let selectedCardIdn = selectedCard?.cardIdn
        return HomeCardTransactionActionPayload(
            localDate: transaction.actionPayload.localDate,
            statementDescription: transaction.actionPayload.statementDescription,
            descriptionExtended: transaction.actionPayload.descriptionExtended,
            amount: transaction.actionPayload.amount,
            currency: transaction.actionPayload.currency,
            accountAmount: transaction.actionPayload.accountAmount,
            accountCurrency: transaction.actionPayload.accountCurrency,
            rrn: transaction.actionPayload.rrn,
            srn: transaction.actionPayload.srn,
            arn: transaction.actionPayload.arn,
            country: transaction.actionPayload.country,
            city: transaction.actionPayload.city,
            mcc: transaction.actionPayload.mcc,
            cardIdn: transaction.actionPayload.cardIdn ?? selectedCardIdn,
            authCode: transaction.actionPayload.authCode,
            transCondition: transaction.actionPayload.transCondition,
            fee: transaction.actionPayload.fee,
            feeCurrency: transaction.actionPayload.feeCurrency,
            transactionStatus: transaction.actionPayload.transactionStatus,
            rechargeOrderStatus: transaction.actionPayload.rechargeOrderStatus,
            isChargebackEligible: transaction.actionPayload.isChargebackEligible
        )
    }

    private func applyFavoriteSelection(cardIdn: Int) {
        cards = cards.map { card in
            guard card.cardType != .stored else { return card }
            return HomeCard(
                cardIdn: card.cardIdn,
                token: card.token,
                name: card.name,
                maskedPan: card.maskedPan,
                encryptedPan: card.encryptedPan,
                fullPan: card.fullPan,
                expiryDate: card.expiryDate,
                bankLogoURL: card.bankLogoURL,
                amount: card.amount,
                currency: card.currency,
                iban: card.iban,
                cardType: card.cardType,
                cardNetwork: card.cardNetwork,
                isLocked: card.isLocked,
                isFavorite: card.cardIdn == cardIdn,
                hasCashbackRule: card.hasCashbackRule,
                interestAmount: card.interestAmount,
                minimumPayment: card.minimumPayment,
                monthlyDebt: card.monthlyDebt,
                installmentCard: card.installmentCard,
                isJunior: card.isJunior,
                hasTurnover: card.hasTurnover,
                isAdvanceLoan: card.isAdvanceLoan,
                cardProductRaw: card.cardProductRaw,
                isPremium: card.isPremium
            )
        }
        rebuildCarousel()
    }

    // MARK: - Favorite

    package func toggleFavorite(cardId: String) {
        guard let card = cards.first(where: { ($0.token ?? String($0.cardIdn)) == cardId }),
              card.cardType != .stored else { return }
        Task {
            try? await setFavoriteCardUseCase.execute(cardIdn: card.cardIdn)
            applyFavoriteSelection(cardIdn: card.cardIdn)
        }
    }

    // MARK: - Static Actions

    private var homeQuickActions: RBHomeFlowQuickActionsModel {
        guard let selectedCard else {
            return RBHomeFlowQuickActionsModel(items: [])
        }

        if selectedCard.cardType == .stored {
            return RBHomeFlowQuickActionsModel(items: [
                .init(
                    id: "qa-payment",
                    title: "Ödənişlər",
                    icon: .custom(.actionQuickPayment),
                    onTap: { [weak self, onPaymentsTap] in
                        onPaymentsTap(self?.paymentSource(for: self?.selectedCard) ?? "")
                    }
                )
            ])
        }

        if selectedCard.installmentCard {
            return RBHomeFlowQuickActionsModel(items: [
                .init(id: "qa-installment", title: "Taksit", icon: .custom(.actionQuickTransfer), onTap: { [weak self] in
                    self?.handleInstallmentStatementTap()
                }),
                .init(id: "qa-pay-loan", title: "Kredit ödə", icon: .custom(.actionQuickTopup), onTap: { [weak self] in
                    self?.handleCreditCardPaymentTap()
                }),
                .init(
                    id: "qa-payment",
                    title: "Ödənişlər",
                    icon: .custom(.actionQuickPayment),
                    onTap: { [weak self, onPaymentsTap] in
                        onPaymentsTap(self?.paymentSource(for: self?.selectedCard) ?? "")
                    }
                )
            ])
        }

        if selectedCard.cardType == .credit {
            return RBHomeFlowQuickActionsModel(items: [
                .init(id: "qa-transfer", title: "Karta Köçürmə", icon: .custom(.actionQuickTransfer), onTap: { [weak self] in
                    self?.handleCardToCardTap()
                }),
                .init(id: "qa-pay-loan", title: "Kredit ödə", icon: .custom(.actionQuickTopup), onTap: { [weak self] in
                    self?.handleCreditCardPaymentTap()
                }),
                .init(
                    id: "qa-payment",
                    title: "Ödənişlər",
                    icon: .custom(.actionQuickPayment),
                    onTap: { [weak self, onPaymentsTap] in
                        onPaymentsTap(self?.paymentSource(for: self?.selectedCard) ?? "")
                    }
                )
            ])
        }

        return RBHomeFlowQuickActionsModel(items: [
            .init(id: "qa-transfer", title: "Karta Köçürmə", icon: .custom(.actionQuickTransfer), onTap: { [weak self] in
                self?.handleCardToCardTap()
            }),
            .init(id: "qa-deposit", title: "Mədaxil", icon: .custom(.actionQuickTopup), onTap: { [weak self] in
                self?.handleTopupTap()
            }),
            .init(
                id: "qa-payment",
                title: "Ödənişlər",
                icon: .custom(.actionQuickPayment),
                onTap: { [weak self, onPaymentsTap] in
                    onPaymentsTap(self?.paymentSource(for: self?.selectedCard) ?? "")
                }
            )
        ])
    }

    private var detailQuickActions: RBHomeFlowQuickActionsModel {
        guard let selectedCard else {
            return RBHomeFlowQuickActionsModel(items: [])
        }

        if selectedCard.cardType == .stored {
            return RBHomeFlowQuickActionsModel(items: [
                .init(id: "dqa-remove", title: "Kartı sil", icon: .asset("remove_card_icon", bundle: .module), iconSize: .custom(40), onTap: { [weak self] in
                    self?.handleCardRemoveTap()
                })
            ])
        }

        var items: [RBHomeFlowQuickActionItem] = []

        if selectedCard.isLocked == false, selectedCard.isJunior == false {
            items.append(
                .init(id: "dqa-apple-pay", title: "Apple Pay", icon: .asset("apple_pay_icon", bundle: .module), iconSize: .custom(40), onTap: { [weak self] in
                    self?.handleCardApplePayTap()
                })
            )
            items.append(
                .init(id: "dqa-digital-skin", title: "Digital Skin", icon: .asset("digital_skin_icon", bundle: .module), iconSize: .custom(40), onTap: { [weak self] in
                    self?.handleCardDigitalSkinTap()
                })
            )
        }

        items.append(
            .init(
                id: selectedCard.isLocked ? "dqa-unblock" : "dqa-block",
                title: selectedCard.isLocked ? "Bloku aç" : "Kartı blokla",
                icon: .asset(selectedCard.isLocked ? "card_unblock_icon" : "card_block_icon", bundle: .module),
                iconSize: .custom(40),
                onTap: { [weak self] in
                    self?.handleCardBlockToggleTap()
                }
            )
        )

        if selectedCard.installmentCard, selectedCard.isLocked == false, selectedCard.isJunior == false {
            items.append(
                .init(id: "dqa-card-to-card", title: "Karta köçürmə", icon: .asset("quickActionToCard", bundle: .module), iconSize: .custom(36), onTap: { [weak self] in
                    self?.handleCardToCardTap()
                })
            )
        }

        return RBHomeFlowQuickActionsModel(items: items)
    }

    private var cardServiceActions: RBHomeFlowDetailActionsModel {
        guard let selectedCard else {
            return RBHomeFlowDetailActionsModel(items: [])
        }

        if selectedCard.cardType == .stored {
            return RBHomeFlowDetailActionsModel(title: "Kart xidmətləri", items: [
                .init(
                    id: "svc-recharge-rename",
                    title: "Kart adını dəyiş",
                    description: "Stored kart adını yenilə",
                    icon: .iconEdit,
                    legacyIconAssetName: "recharge_card_change_name_icon",
                    onTap: { [weak self] in
                        self?.handleCardDetailSectionTap(sectionID: 6)
                    }
                )
            ])
        }

        var items: [RBHomeFlowDetailActionItem] = [
            .init(
                id: "svc-card-info",
                title: "Kart məlumatları",
                description: "Rekvizitlər, çıxarışlar, faiz və kart adını dəyiş",
                icon: .iconInfoSquare,
                legacyIconAssetName: "card_info_detail_icon",
                onTap: { [weak self] in
                    self?.handleCardDetailSectionTap(sectionID: 0)
                }
            )
        ]

        if selectedCard.cardType == .credit || selectedCard.installmentCard || selectedCard.isAdvanceLoan {
            let description: String
            if selectedCard.installmentCard {
                description = "Taksit və kredit məlumatlarını göstər"
            } else if selectedCard.cardType == .credit {
                description = "Kredit xətti və borc məlumatlarını göstər"
            } else {
                description = "Advance loan məlumatlarını göstər"
            }

            items.append(
                .init(
                    id: "svc-loan-info",
                    title: "Kredit məlumatları",
                    description: description,
                    icon: .iconPaper,
                    legacyIconAssetName: "card_info_credit_detail_icon",
                    onTap: { [weak self] in
                        self?.handleCardDetailSectionTap(sectionID: 3)
                    }
                )
            )
        }

        items.append(
            .init(
                id: "svc-limits",
                title: "Limitlər",
                description: "Xərc, pulsuz əməliyyat və uzatma limitlərini idarə et",
                icon: .iconFilterAdvanced,
                legacyIconAssetName: "card_info_limits_icon",
                onTap: { [weak self] in
                    self?.handleCardDetailSectionTap(sectionID: 2)
                }
            )
        )

        items.append(
            .init(
                id: "svc-security",
                title: "Təhlükəsizlik",
                description: "PIN, kart report və təhlükəsizlik seçimləri",
                icon: .iconShieldDone,
                legacyIconAssetName: "card_info_security_icon",
                onTap: { [weak self] in
                    self?.handleCardDetailSectionTap(sectionID: 1)
                }
            )
        )

        if selectedCard.isJunior == false {
            items.append(
                .init(
                    id: "svc-carbon",
                    title: "Karbon kalkulyatoru",
                    description: "Karbon emissiyası statistikasını göstər",
                    icon: .iconChart,
                    legacyIconAssetName: "card_info_carbon_cloud",
                    onTap: { [weak self] in
                        self?.handleCardDetailSectionTap(sectionID: 10)
                    }
                )
            )
        }

        items.append(
            .init(
                id: "svc-sms",
                title: "SMS bildirişləri",
                description: "Kart üzrə SMS status və xidmət məlumatları",
                icon: .iconMessage,
                legacyIconAssetName: "card_info_sms_icon",
                onTap: { [weak self] in
                    self?.handleCardDetailSectionTap(sectionID: 5)
                }
            )
        )

        if selectedCard.cardNetwork == .visa {
            items.append(
                .init(
                    id: "svc-subscriptions",
                    title: "Abunəliklər",
                    description: "Visa abunəlik və recurring ödənişləri göstər",
                    icon: .iconPaper,
                    legacyIconAssetName: "card_info_subscribe_icon",
                    onTap: { [weak self] in
                        self?.handleCardDetailSectionTap(sectionID: 4)
                    }
                )
            )
        }

        return RBHomeFlowDetailActionsModel(title: "Kart xidmətləri", items: items)
    }
}
