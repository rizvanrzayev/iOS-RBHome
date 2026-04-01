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
    private let onAccountRenameTap: (String, String, String?, String?, @escaping (String) -> Void) -> Void
    private let onAccountRequisitesTap: (String, String) -> Void
    private let onAccountDocumentsTap: () -> Void

    package init(
        fetchAccountsUseCase: FetchAccountsUseCase,
        fetchRecordsUseCase: FetchAccountRecordsUseCase,
        onPaymentsTap: @escaping (String) -> Void = { _ in },
        onTransferTap: @escaping () -> Void = {},
        onAccountRenameTap: @escaping (String, String, String?, String?, @escaping (String) -> Void) -> Void = { _, _, _, _, _ in },
        onAccountRequisitesTap: @escaping (String, String) -> Void = { _, _ in },
        onAccountDocumentsTap: @escaping () -> Void = {}
    ) {
        self.fetchAccountsUseCase = fetchAccountsUseCase
        self.fetchRecordsUseCase = fetchRecordsUseCase
        self.onPaymentsTap = onPaymentsTap
        self.onTransferTap = onTransferTap
        self.onAccountRenameTap = onAccountRenameTap
        self.onAccountRequisitesTap = onAccountRequisitesTap
        self.onAccountDocumentsTap = onAccountDocumentsTap
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
        let title = selectedAccountTitle
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

    private var selectedAccountTitle: String {
        let nickname = selectedAccount?.nickname?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return nickname.isEmpty ? (selectedAccount?.accountName ?? "Hesab") : nickname
    }

    private func updateNickname(_ nickname: String) {
        guard let selectedAccountNumber else { return }
        accounts = accounts.map { account in
            guard account.accountNumber == selectedAccountNumber else { return account }
            return HomeAccount(
                accountNumber: account.accountNumber,
                accountName: account.accountName,
                nickname: nickname,
                iban: account.iban,
                amount: account.amount,
                currency: account.currency,
                accountTypeRaw: account.accountTypeRaw
            )
        }
        cardsState = .loaded(makeCarousel(from: accounts))
    }

    private func handleRenameTap() {
        guard let account = selectedAccount else { return }
        onAccountRenameTap(
            account.accountNumber,
            account.accountName,
            account.nickname,
            account.accountTypeRaw
        ) { [weak self] nickname in
            self?.updateNickname(nickname)
        }
    }

    private func handleRequisitesTap() {
        guard let account = selectedAccount, account.iban.isEmpty == false else { return }
        onAccountRequisitesTap(account.iban, account.currency)
    }

    private func handleDocumentsTap() {
        onAccountDocumentsTap()
    }

    // MARK: - Mappers

    private func makeCarousel(from accounts: [HomeAccount]) -> RBHomeFlowCarouselModel {
        RBHomeFlowCarouselModel(items: accounts.map { acc in
            let nickname = acc.nickname?.trimmingCharacters(in: .whitespacesAndNewlines)
            let preferredTitle = (nickname?.isEmpty == false) ? (nickname ?? acc.accountName) : acc.accountName
            let detailValue = acc.iban.isEmpty ? acc.accountNumber : acc.iban
            return RBHomeFlowCarouselItem(
                id: acc.accountNumber,
                title: preferredTitle,
                subtitle: acc.iban.isEmpty ? acc.accountNumber : acc.iban,
                amount: HomeAmountFormatter.format(acc.amount, currency: acc.currency),
                detailCaption: preferredTitle,
                detailInfoTitle: "IBAN",
                detailInfoValue: detailValue
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
            .init(id: "svc-rename", title: "Hesab adını dəyiş",
                  description: selectedAccount?.nickname ?? "", systemImage: "pencil", legacyIconAssetName: "accountInfoEdit", onTap: { [weak self] in
                self?.handleRenameTap()
            }),
            .init(id: "svc-requisites", title: "Rekvizitlər",
                  description: "Hesab nömrəsi, IBAN və digər məlumatlar", systemImage: "doc.text.fill", legacyIconAssetName: "requisities", onTap: { [weak self] in
                self?.handleRequisitesTap()
            }),
            .init(id: "svc-documents", title: "Çıxarış və arayışlar",
                  description: "Arayış və çıxarış növlərini seç", systemImage: "arrow.down.doc.fill", legacyIconAssetName: "account_info_documents", onTap: { [weak self] in
                self?.handleDocumentsTap()
            })
        ])
    }
}
