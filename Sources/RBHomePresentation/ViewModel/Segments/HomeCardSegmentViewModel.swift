import Foundation
import RBHomeDomain

@MainActor
package final class HomeCardSegmentViewModel: ObservableObject {
    @Published var cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel> = .loading
    @Published var bonusSummaryState: RBHomeFlowSectionState<RBHomeFlowBonusSummaryModel> = .loading
    @Published var panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel> = .loading

    private var cards: [HomeCard] = []
    private var selectedCardIdn: Int?

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
                bonusSummaryState = .hidden
                panelState = .empty(title: "Əməliyyat yoxdur", message: nil)
            } else {
                cardsState = .loaded(makeCarousel(from: fetched))
                if let first = fetched.first(where: { $0.cardType != .stored }) {
                    selectedCardIdn = first.cardIdn
                    await loadCardDetails(cardIdn: first.cardIdn)
                } else {
                    bonusSummaryState = .hidden
                    panelState = .empty(title: "Əməliyyat yoxdur", message: nil)
                }
            }
        } catch {
            cardsState = .error(title: "Xəta", message: error.localizedDescription)
            bonusSummaryState = .hidden
            panelState = .error(title: "Xəta", message: nil)
        }
    }

    func onCardSelected(cardId: String) async {
        let selected = cards.first { String($0.cardIdn) == cardId || $0.token == cardId }
        guard let selected, selected.cardIdn != selectedCardIdn || selected.token != nil else { return }

        if selected.cardType == .stored {
            selectedCardIdn = 0
            bonusSummaryState = .hidden
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
            bonusSummaryState = .loaded(makeBonusSummary(from: bonus))
            panelState = transactions.isEmpty
                ? .empty(title: "Əməliyyat yoxdur", message: nil)
                : .loaded(makePanel(from: transactions))
        } catch {
            bonusSummaryState = .error(title: "Xəta", message: error.localizedDescription)
            panelState = .error(title: "Xəta", message: error.localizedDescription)
        }
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
            return RBHomeFlowCarouselItem(
                id: id,
                title: card.name,
                subtitle: card.maskedPan,
                amount: amount,
                networkAsset: card.cardNetwork.assetName,
                backgroundAsset: card.backgroundAsset
            )
        })
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
            }
        )
    }

    // MARK: - Static Actions

    private var homeQuickActions: RBHomeFlowQuickActionsModel {
        if selectedCard?.cardType == .stored {
            return RBHomeFlowQuickActionsModel(items: [
                .init(id: "qa-payment", title: "Ödənişlər", systemImage: "creditcard", onTap: {})
            ])
        }
        return RBHomeFlowQuickActionsModel(items: [
            .init(id: "qa-transfer", title: "Karta Köçürmə", systemImage: "arrow.right.to.line", onTap: {}),
            .init(id: "qa-deposit", title: "Mədaxil", systemImage: "arrow.down.circle", onTap: {}),
            .init(id: "qa-payment", title: "Ödənişlər", systemImage: "creditcard", onTap: {})
        ])
    }

    private var detailQuickActions: RBHomeFlowQuickActionsModel {
        if selectedCard?.cardType == .stored {
            return RBHomeFlowQuickActionsModel(items: [
                .init(id: "dqa-payment", title: "Ödənişlər", systemImage: "creditcard", onTap: {})
            ])
        }
        return RBHomeFlowQuickActionsModel(items: [
            .init(id: "dqa-transfer", title: "Karta Köçürmə", systemImage: "arrow.right.to.line", onTap: {}),
            .init(id: "dqa-deposit", title: "Mədaxil", systemImage: "arrow.down.circle", onTap: {}),
            .init(id: "dqa-payment", title: "Ödənişlər", systemImage: "creditcard", onTap: {})
        ])
    }

    private var cardServiceActions: RBHomeFlowDetailActionsModel {
        RBHomeFlowDetailActionsModel(title: "Kart xidmətləri", items: [
            .init(id: "svc-lock", title: "Kartı blokla",
                  description: "Müvəqqəti istifadəni dayandır", systemImage: "lock.fill", onTap: {}),
            .init(id: "svc-limit", title: "Limit idarəetməsi",
                  description: "Gündəlik xərcləmə limitini dəyiş", systemImage: "slider.horizontal.3", onTap: {}),
            .init(id: "svc-details", title: "Kart rekvizitləri",
                  description: "Tam kart məlumatlarını gör", systemImage: "doc.text.fill", onTap: {}),
            .init(id: "svc-statement", title: "Çıxarış sifariş et",
                  description: "Hesab çıxarışını yüklə", systemImage: "arrow.down.doc.fill", onTap: {})
        ])
    }
}
