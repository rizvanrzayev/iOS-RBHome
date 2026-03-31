import Foundation
import RBHomeDomain

@MainActor
package final class HomeAccountSegmentViewModel: ObservableObject {
    @Published var cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel> = .loading
    @Published var operationsState: RBHomeFlowSectionState<RBHomeFlowInfoListModel> = .loading
    @Published var panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel> = .loading

    private var accounts: [HomeAccount] = []
    private var selectedAccountNumber: String?
    private var rawRecords: [HomeAccountRecord] = []
    private var panelSearchText: String = ""
    private var panelDateFilter: RBHomeFlowPanelFilter? = nil

    private let fetchAccountsUseCase: FetchAccountsUseCase
    private let fetchRecordsUseCase: FetchAccountRecordsUseCase
    private let onPaymentsTap: (String) -> Void
    private let onTransferTap: () -> Void

    package init(
        fetchAccountsUseCase: FetchAccountsUseCase,
        fetchRecordsUseCase: FetchAccountRecordsUseCase,
        onPaymentsTap: @escaping (String) -> Void = { _ in },
        onTransferTap: @escaping () -> Void = {}
    ) {
        self.fetchAccountsUseCase = fetchAccountsUseCase
        self.fetchRecordsUseCase = fetchRecordsUseCase
        self.onPaymentsTap = onPaymentsTap
        self.onTransferTap = onTransferTap
    }

    func load() async {
        cardsState = .loading
        operationsState = .loading
        panelState = .loading

        do {
            let fetched = try await fetchAccountsUseCase.execute()
            accounts = fetched

            if fetched.isEmpty {
                cardsState = .empty(title: "Hesab yoxdur", message: nil)
                operationsState = .empty(title: "Əməliyyat yoxdur", message: nil)
                panelState = .empty(title: "Əməliyyat yoxdur", message: nil)
            } else {
                cardsState = .loaded(makeCarousel(from: fetched))
                if let first = fetched.first {
                    selectedAccountNumber = first.accountNumber
                    await loadRecords(accountNumber: first.accountNumber)
                }
            }
        } catch {
            cardsState = .error(title: "Xəta", message: error.localizedDescription)
            operationsState = .error(title: "Xəta", message: nil)
            panelState = .error(title: "Xəta", message: nil)
        }
    }

    func onAccountSelected(accountNumber: String) async {
        guard accountNumber != selectedAccountNumber else { return }
        selectedAccountNumber = accountNumber
        operationsState = .loading
        panelState = .loading
        await loadRecords(accountNumber: accountNumber)
    }

    private func loadRecords(accountNumber: String) async {
        do {
            let records = try await fetchRecordsUseCase.execute(accountNumber: accountNumber)
            operationsState = records.isEmpty
                ? .empty(title: "Əməliyyat yoxdur", message: nil)
                : .loaded(makeOperationsList(from: records))
            rawRecords = records
            panelSearchText = ""
            panelDateFilter = nil
            rebuildPanel()
        } catch {
            operationsState = .error(title: "Xəta", message: error.localizedDescription)
            panelState = .error(title: "Xəta", message: error.localizedDescription)
        }
    }

    private func rebuildPanel() {
        panelState = .loaded(makePanel(from: filteredRecords()))
    }

    private func filteredRecords() -> [HomeAccountRecord] {
        var list = rawRecords
        if !panelSearchText.isEmpty {
            list = list.filter { $0.title.localizedCaseInsensitiveContains(panelSearchText) }
        }
        if let filter = panelDateFilter {
            let range = filter.dateRange
            list = list.filter { $0.operDate >= range.from && $0.operDate <= range.to }
        }
        return list
    }

    // MARK: - Computed UI Models

    var homeModel: RBHomeFlowAccountHomeModel {
        RBHomeFlowAccountHomeModel(
            cardsState: cardsState,
            actionsState: .loaded(homeQuickActions),
            operationsState: operationsState,
            panelState: panelState
        )
    }

    var detailModel: RBHomeFlowAccountDetailModel {
        let selected = selectedAccount
        let title = selected?.accountName ?? "Hesab"
        return RBHomeFlowAccountDetailModel(
            title: title,
            cardsState: cardsState,
            infoState: selected.map { .loaded(makeInfoList(from: $0)) } ?? .loading,
            actionsState: .loaded(accountServiceActions),
            panelState: panelState
        )
    }

    private var selectedAccount: HomeAccount? {
        accounts.first { $0.accountNumber == selectedAccountNumber } ?? accounts.first
    }

    private var paymentSource: String {
        let iban = selectedAccount?.iban ?? ""
        return iban.isEmpty ? (selectedAccount?.accountNumber ?? "") : iban
    }

    // MARK: - Mappers

    private func makeCarousel(from accounts: [HomeAccount]) -> RBHomeFlowCarouselModel {
        RBHomeFlowCarouselModel(items: accounts.map { acc in
            RBHomeFlowCarouselItem(
                id: acc.accountNumber,
                title: acc.accountName,
                subtitle: acc.iban,
                amount: HomeAmountFormatter.format(acc.amount, currency: acc.currency)
            )
        })
    }

    private func makeOperationsList(from records: [HomeAccountRecord]) -> RBHomeFlowInfoListModel {
        RBHomeFlowInfoListModel(
            title: "Son əməliyyatlar",
            items: records.prefix(5).enumerated().map { index, record in
                let sign = record.isCredit ? "+" : "-"
                return RBHomeFlowInfoListItem(
                    id: "op-\(index)",
                    title: record.title,
                    value: "\(sign)\(HomeAmountFormatter.format(record.amount, currency: record.currency))"
                )
            }
        )
    }

    private func makePanel(from records: [HomeAccountRecord]) -> RBHomeFlowPanelModel {
        RBHomeFlowPanelModel(
            title: "Əməliyyatlar",
            items: records.prefix(20).enumerated().map { index, record in
                let sign = record.isCredit ? "+" : "-"
                return RBHomeFlowPanelItem(
                    id: "rec-\(index)",
                    date: HomeAmountFormatter.formatDate(record.operDate),
                    title: record.title,
                    amount: "\(sign)\(HomeAmountFormatter.format(record.amount, currency: record.currency))",
                    isCredit: record.isCredit
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

    private func makeInfoList(from account: HomeAccount) -> RBHomeFlowInfoListModel {
        let items: [RBHomeFlowInfoListItem] = [
            .init(id: "info-iban", title: "IBAN", value: account.iban),
            .init(id: "info-currency", title: "Valyuta", value: account.currency)
        ]
        return RBHomeFlowInfoListModel(title: "Hesab məlumatları", items: items)
    }

    // MARK: - Static Actions

    private var homeQuickActions: RBHomeFlowQuickActionsModel {
        RBHomeFlowQuickActionsModel(items: [
            .init(id: "qa-topup", title: "Doldur", icon: .custom(.actionQuickTopup), onTap: onTransferTap),
            .init(
                id: "qa-payment",
                title: "Ödənişlər",
                icon: .custom(.actionQuickPayment),
                onTap: { [weak self, onPaymentsTap] in
                    onPaymentsTap(self?.paymentSource ?? "")
                }
            ),
            .init(id: "qa-transfer", title: "Köçürmə", icon: .custom(.actionQuickTransfer), onTap: onTransferTap)
        ])
    }

    private var accountServiceActions: RBHomeFlowDetailActionsModel {
        RBHomeFlowDetailActionsModel(title: "Hesab xidmətləri", items: [
            .init(id: "svc-requisites", title: "Rekvizitlər",
                  description: "Hesab rekvizitlərini paylaş", systemImage: "doc.text.fill", onTap: {}),
            .init(id: "svc-statement", title: "Çıxarış",
                  description: "Hesab çıxarışını yüklə", systemImage: "arrow.down.doc.fill", onTap: {}),
            .init(id: "svc-transfer", title: "Köçürmə",
                  description: "Hesabdan köçürmə et", systemImage: "arrow.left.arrow.right", onTap: {}),
            .init(id: "svc-close", title: "Hesabı bağla",
                  description: "Hesabı bağlamaq üçün müraciət et", systemImage: "xmark.circle.fill", onTap: {})
        ])
    }
}
