import Foundation
import RBHomeDomain

@MainActor
package final class HomeCardSegmentViewModel: ObservableObject {
    @Published var cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel> = .loading
    @Published var bonusSummaryState: RBHomeFlowSectionState<RBHomeFlowBonusSummaryModel> = .loading
    @Published var panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel> = .loading

    private var cards: [HomeCard] = []
    private var selectedCardIdn: Int?
    private var bonusPerCard: [Int: HomeCardBonusPoint] = [:]
    private var rawTransactions: [HomeCardTransaction] = []
    private var panelSearchText: String = ""
    private var panelDateFilter: RBHomeFlowPanelFilter? = nil

    private let fetchCardsUseCase: FetchCardsUseCase
    private let fetchTransactionsUseCase: FetchCardTransactionsUseCase
    private let fetchBonusUseCase: FetchCardBonusUseCase

    package init(
        fetchCardsUseCase: FetchCardsUseCase,
        fetchTransactionsUseCase: FetchCardTransactionsUseCase,
        fetchBonusUseCase: FetchCardBonusUseCase
    ) {
        self.fetchCardsUseCase = fetchCardsUseCase
        self.fetchTransactionsUseCase = fetchTransactionsUseCase
        self.fetchBonusUseCase = fetchBonusUseCase
    }

    func load() async {
        cardsState = .loading
        bonusSummaryState = .loading
        panelState = .loading

        do {
            let fetched = try await fetchCardsUseCase.execute()
            cards = fetched

            if fetched.isEmpty {
                cardsState = .empty(title: "Kart yoxdur", message: nil)
                bonusSummaryState = .empty(title: "Bonus məlumatı yoxdur", message: nil)
                panelState = .empty(title: "Əməliyyat yoxdur", message: nil)
            } else {
                cardsState = .loaded(makeCarousel(from: fetched))
                if let first = fetched.first(where: { $0.cardType != .stored }) {
                    selectedCardIdn = first.cardIdn
                    await loadCardDetails(cardIdn: first.cardIdn)
                } else {
                    bonusSummaryState = .empty(title: "Bonus məlumatı yoxdur", message: nil)
                    panelState = .empty(title: "Əməliyyat yoxdur", message: nil)
                }
            }
        } catch {
            cardsState = .error(title: "Xəta", message: error.localizedDescription)
            bonusSummaryState = .error(title: "Xəta", message: nil)
            panelState = .error(title: "Xəta", message: nil)
        }
    }

    func onCardSelected(cardId: String) async {
        let selected = cards.first { String($0.cardIdn) == cardId || $0.token == cardId }
        guard let selected, selected.cardIdn != selectedCardIdn || selected.token != nil else { return }

        if selected.cardType == .stored {
            selectedCardIdn = 0
            bonusSummaryState = .empty(title: "Bonus məlumatı yoxdur", message: nil)
            panelState = .empty(title: "Əməliyyat yoxdur", message: nil)
            return
        }

        selectedCardIdn = selected.cardIdn
        bonusSummaryState = .loading
        panelState = .loading
        await loadCardDetails(cardIdn: selected.cardIdn)
    }

    private func loadCardDetails(cardIdn: Int) async {
        async let bonusResult = fetchBonusUseCase.execute(cardIdn: cardIdn)
        async let transResult = fetchTransactionsUseCase.execute(cardIdn: cardIdn)

        do {
            let (bonus, transactions) = try await (bonusResult, transResult)
            bonusPerCard[cardIdn] = bonus
            bonusSummaryState = .loaded(makeBonusSummary(from: bonus))
            rawTransactions = transactions
            panelSearchText = ""
            panelDateFilter = nil
            rebuildCarousel()
            rebuildPanel()
        } catch {
            bonusSummaryState = .error(title: "Xəta", message: error.localizedDescription)
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
        RBHomeFlowCardHomeModel(
            cardsState: cardsState,
            quickActionsState: .loaded(homeQuickActions),
            bonusSummaryState: bonusSummaryState,
            panelState: panelState
        )
    }

    var detailModel: RBHomeFlowCardDetailModel {
        let title = selectedCard?.name ?? "Kart"
        return RBHomeFlowCardDetailModel(
            title: title,
            cardsState: cardsState,
            quickActionsState: .loaded(detailQuickActions),
            actionsState: .loaded(cardServiceActions)
        )
    }

    private var selectedCard: HomeCard? {
        cards.first { $0.cardIdn == selectedCardIdn } ?? cards.first
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
                bottomLeadingLabel: bottomLeadingLabel
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

    private func makeBonusSummary(from bonus: HomeCardBonusPoint) -> RBHomeFlowBonusSummaryModel {
        RBHomeFlowBonusSummaryModel(items: [
            .init(id: "bonus-total", systemImage: "star.fill",
                  title: "Bonus balans", value: "\(Int(bonus.totalPoint)) xal"),
            .init(id: "bonus-current", systemImage: "percent",
                  title: "Cashback", value: HomeAmountFormatter.format(bonus.currentPoint, currency: "AZN"))
        ])
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
                    amount: "\(sign)\(HomeAmountFormatter.format(tx.amount, currency: tx.currency))",
                    isCredit: tx.isCredit
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

    // MARK: - Static Actions

    private var homeQuickActions: RBHomeFlowQuickActionsModel {
        if selectedCard?.cardType == .stored {
            return RBHomeFlowQuickActionsModel(items: [
                .init(id: "qa-payment", title: "Ödənişlər", icon: .custom(.actionPayment), onTap: {})
            ])
        }
        return RBHomeFlowQuickActionsModel(items: [
            .init(id: "qa-transfer", title: "Karta Köçürmə", icon: .custom(.actionTransfer), onTap: {}),
            .init(id: "qa-deposit", title: "Mədaxil", icon: .custom(.actionTopup), onTap: {}),
            .init(id: "qa-payment", title: "Ödənişlər", icon: .custom(.actionPayment), onTap: {})
        ])
    }

    private var detailQuickActions: RBHomeFlowQuickActionsModel {
        if selectedCard?.cardType == .stored {
            return RBHomeFlowQuickActionsModel(items: [
                .init(id: "dqa-payment", title: "Ödənişlər", icon: .custom(.actionPayment), onTap: {})
            ])
        }
        return RBHomeFlowQuickActionsModel(items: [
            .init(id: "dqa-transfer", title: "Karta Köçürmə", icon: .custom(.actionTransfer), onTap: {}),
            .init(id: "dqa-deposit", title: "Mədaxil", icon: .custom(.actionTopup), onTap: {}),
            .init(id: "dqa-payment", title: "Ödənişlər", icon: .custom(.actionPayment), onTap: {})
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
