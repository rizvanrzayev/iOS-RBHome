import Foundation
import RBHomeDomain

@MainActor
package final class HomeDepositSegmentViewModel: ObservableObject {
    @Published var cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel> = .loading
    @Published var conditionsState: RBHomeFlowSectionState<RBHomeFlowInfoListModel> = .loading
    @Published var panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel> = .loading

    private var deposits: [HomeDeposit] = []
    private var selectedAccountNumber: String?

    private let fetchDepositsUseCase: FetchDepositsUseCase

    package init(fetchDepositsUseCase: FetchDepositsUseCase) {
        self.fetchDepositsUseCase = fetchDepositsUseCase
    }

    func load() async {
        cardsState = .loading
        conditionsState = .loading
        panelState = .empty(title: "Əməliyyat yoxdur", message: nil)

        do {
            let fetched = try await fetchDepositsUseCase.execute()
            deposits = fetched

            if fetched.isEmpty {
                cardsState = .empty(title: "Əmanət yoxdur", message: nil)
                conditionsState = .empty(title: "Şərtlər yoxdur", message: nil)
            } else {
                cardsState = .loaded(makeCarousel(from: fetched))
                if let first = fetched.first {
                    selectedAccountNumber = first.accountNumber
                    conditionsState = .loaded(makeConditions(from: first))
                }
            }
        } catch {
            cardsState = .error(title: "Xəta", message: error.localizedDescription)
            conditionsState = .error(title: "Xəta", message: nil)
        }
    }

    func onDepositSelected(accountNumber: String) {
        guard accountNumber != selectedAccountNumber,
              let deposit = deposits.first(where: { $0.accountNumber == accountNumber })
        else { return }
        selectedAccountNumber = accountNumber
        conditionsState = .loaded(makeConditions(from: deposit))
    }

    // MARK: - Computed UI Models

    var homeModel: RBHomeFlowDepositHomeModel {
        RBHomeFlowDepositHomeModel(
            cardsState: cardsState,
            actionsState: .loaded(homeQuickActions),
            conditionsState: conditionsState,
            panelState: panelState
        )
    }

    var detailModel: RBHomeFlowDepositDetailModel {
        let title = selectedDeposit?.accountName ?? "Əmanət"
        return RBHomeFlowDepositDetailModel(
            title: title,
            cardsState: cardsState,
            conditionsState: conditionsState,
            actionsState: .loaded(depositServiceActions),
            panelState: panelState
        )
    }

    private var selectedDeposit: HomeDeposit? {
        deposits.first { $0.accountNumber == selectedAccountNumber } ?? deposits.first
    }

    // MARK: - Mappers

    private func makeCarousel(from deposits: [HomeDeposit]) -> RBHomeFlowCarouselModel {
        RBHomeFlowCarouselModel(items: deposits.map { deposit in
            RBHomeFlowCarouselItem(
                id: deposit.accountNumber,
                title: deposit.accountName,
                subtitle: deposit.currency,
                amount: HomeAmountFormatter.format(deposit.amount, currency: deposit.currency)
            )
        })
    }

    private func makeConditions(from deposit: HomeDeposit) -> RBHomeFlowInfoListModel {
        var items: [RBHomeFlowInfoListItem] = [
            .init(id: "cond-amount", title: "Məbləğ",
                  value: HomeAmountFormatter.format(deposit.amount, currency: deposit.currency)),
            .init(id: "cond-currency", title: "Valyuta", value: deposit.currency)
        ]
        if deposit.calcInterest > 0 {
            items.append(.init(
                id: "cond-interest",
                title: "Hesablanmış faiz",
                value: HomeAmountFormatter.format(deposit.calcInterest, currency: deposit.currency)
            ))
        }
        return RBHomeFlowInfoListModel(title: "Şərtlər", items: items)
    }

    // MARK: - Static Actions

    private var homeQuickActions: RBHomeFlowQuickActionsModel {
        RBHomeFlowQuickActionsModel(items: [
            .init(id: "qa-renew", title: "Yenilə", icon: .system("arrow.clockwise.circle.fill"), onTap: {}),
            .init(id: "qa-history", title: "Tarix", icon: .system("clock"), onTap: {}),
            .init(id: "qa-calc", title: "Hesabla", icon: .system("percent"), onTap: {}),
            .init(id: "qa-new", title: "Yeni", icon: .system("plus.circle"), onTap: {})
        ])
    }

    private var depositServiceActions: RBHomeFlowDetailActionsModel {
        RBHomeFlowDetailActionsModel(title: "Əmanət xidmətləri", items: [
            .init(id: "svc-close", title: "Erkən bağlama",
                  description: "Əmanəti müddətdən əvvəl bağla", systemImage: "xmark.circle.fill", onTap: {}),
            .init(id: "svc-calc", title: "Faiz hesablaması",
                  description: "Gəlir kalkulyatoru", systemImage: "percent", onTap: {}),
            .init(id: "svc-renew", title: "Yeniləmə şərtləri",
                  description: "Avtoyeniləmə parametrlərini dəyiş", systemImage: "arrow.clockwise.circle.fill", onTap: {}),
            .init(id: "svc-contract", title: "Müqavilə",
                  description: "Əmanət müqaviləsini yüklə", systemImage: "doc.text.fill", onTap: {})
        ])
    }
}
