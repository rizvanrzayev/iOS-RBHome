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
    private let onPaymentsTap: (String) -> Void
    private let onSplitBillTap: (HomeCardTransactionActionPayload) -> Void
    private let onChargebackTap: (HomeCardTransactionActionPayload) -> Void

    private var edvBalance: HomeEDVBalance?

    package init(
        fetchCardsUseCase: FetchCardsUseCase,
        fetchTransactionsUseCase: FetchCardTransactionsUseCase,
        fetchBonusUseCase: FetchCardBonusUseCase,
        fetchEDVBalanceUseCase: FetchEDVBalanceUseCase,
        setFavoriteCardUseCase: SetFavoriteCardUseCase,
        onPaymentsTap: @escaping (String) -> Void = { _ in },
        onSplitBillTap: @escaping (HomeCardTransactionActionPayload) -> Void = { _ in },
        onChargebackTap: @escaping (HomeCardTransactionActionPayload) -> Void = { _ in }
    ) {
        self.fetchCardsUseCase = fetchCardsUseCase
        self.fetchTransactionsUseCase = fetchTransactionsUseCase
        self.fetchBonusUseCase = fetchBonusUseCase
        self.fetchEDVBalanceUseCase = fetchEDVBalanceUseCase
        self.setFavoriteCardUseCase = setFavoriteCardUseCase
        self.onPaymentsTap = onPaymentsTap
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
                isFavorite: card.isFavorite
            )
        })
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
            onTap: {}
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
            onTap: {}
        )

        return .pair(RBHomeFlowRefundPairModel(leading: bonusModel, trailing: edvModel))
    }

    private var edvPlaceholderModel: RBHomeFlowEDVRefundModel {
        RBHomeFlowEDVRefundModel(
            icon: .iconEdv,
            title: "ƏDV geri al",
            titleColor: Color.rb.edvBlue,
            content: .placeholder(subtitle: "Hesabınızı aktivləşdirin və ya qeydiyyatdan keçin"),
            onTap: {}
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

    // MARK: - Favorite

    package func toggleFavorite(cardId: String) {
        guard let card = cards.first(where: { ($0.token ?? String($0.cardIdn)) == cardId }),
              card.cardType != .stored else { return }
        Task {
            try? await setFavoriteCardUseCase.execute(cardIdn: card.cardIdn)
            await load()
        }
    }

    // MARK: - Static Actions

    private var homeQuickActions: RBHomeFlowQuickActionsModel {
        if selectedCard?.cardType == .stored {
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
        return RBHomeFlowQuickActionsModel(items: [
            .init(id: "qa-transfer", title: "Karta Köçürmə", icon: .custom(.actionQuickTransfer), onTap: {}),
            .init(id: "qa-deposit", title: "Mədaxil", icon: .custom(.actionQuickTopup), onTap: {}),
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
        if selectedCard?.cardType == .stored {
            return RBHomeFlowQuickActionsModel(items: [
                .init(
                    id: "dqa-payment",
                    title: "Ödənişlər",
                    icon: .custom(.actionQuickPayment),
                    onTap: { [weak self, onPaymentsTap] in
                        onPaymentsTap(self?.paymentSource(for: self?.selectedCard) ?? "")
                    }
                )
            ])
        }
        return RBHomeFlowQuickActionsModel(items: [
            .init(id: "dqa-transfer", title: "Karta Köçürmə", icon: .custom(.actionQuickTransfer), onTap: {}),
            .init(id: "dqa-deposit", title: "Mədaxil", icon: .custom(.actionQuickTopup), onTap: {}),
            .init(
                id: "dqa-payment",
                title: "Ödənişlər",
                icon: .custom(.actionQuickPayment),
                onTap: { [weak self, onPaymentsTap] in
                    onPaymentsTap(self?.paymentSource(for: self?.selectedCard) ?? "")
                }
            )
        ])
    }

    private var cardServiceActions: RBHomeFlowDetailActionsModel {
        RBHomeFlowDetailActionsModel(title: "Kart xidmətləri", items: [
            .init(id: "svc-lock", title: "Kartı blokla",
                  description: "Müvəqqəti istifadəni dayandır", icon: .iconLock, onTap: {}),
            .init(id: "svc-limit", title: "Limit idarəetməsi",
                  description: "Gündəlik xərcləmə limitini dəyiş", icon: .iconFilterAdvanced, onTap: {}),
            .init(id: "svc-details", title: "Kart rekvizitləri",
                  description: "Tam kart məlumatlarını gör", icon: .iconPaper, onTap: {}),
            .init(id: "svc-statement", title: "Çıxarış sifariş et",
                  description: "Hesab çıxarışını yüklə", icon: .iconPaperUpload, onTap: {})
        ])
    }
}
