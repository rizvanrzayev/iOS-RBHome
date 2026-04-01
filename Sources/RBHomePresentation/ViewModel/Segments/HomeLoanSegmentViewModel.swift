import Foundation
import RBDesignSystem
import RBHomeDomain

@MainActor
package final class HomeLoanSegmentViewModel: ObservableObject {
    private enum LoanRecordFilter: Int {
        case ongoing
        case paid

        var title: String {
            switch self {
            case .ongoing: return "Davam edən"
            case .paid: return "Ödənmiş"
            }
        }
    }

    @Published var cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel> = .loading
    @Published var scheduleState: RBHomeFlowSectionState<RBHomeFlowInfoListModel> = .loading
    @Published var panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel> = .loading

    private var loans: [HomeLoan] = []
    private var selectedContractNumber: String?
    private var selectedFilter: LoanRecordFilter = .ongoing
    private var allScheduleRecords: [HomeLoanScheduleRecord] = []

    private let fetchLoansUseCase: FetchLoansUseCase
    private let fetchScheduleUseCase: FetchLoanScheduleUseCase
    private let onLoanPaymentTap: (String) -> Void
    private let onMortgageLoanPaymentTap: (String, String) -> Void
    private let onLoanOrderTap: () -> Void
    private let onLoanRequestTap: () -> Void
    private let onEarlyLoanPaymentTap: (String) -> Void
    private let onLoanScheduleTap: (String) -> Void

    package init(
        fetchLoansUseCase: FetchLoansUseCase,
        fetchScheduleUseCase: FetchLoanScheduleUseCase,
        onLoanPaymentTap: @escaping (String) -> Void = { _ in },
        onMortgageLoanPaymentTap: @escaping (String, String) -> Void = { _, _ in },
        onLoanOrderTap: @escaping () -> Void = {},
        onLoanRequestTap: @escaping () -> Void = {},
        onEarlyLoanPaymentTap: @escaping (String) -> Void = { _ in },
        onLoanScheduleTap: @escaping (String) -> Void = { _ in }
    ) {
        self.fetchLoansUseCase = fetchLoansUseCase
        self.fetchScheduleUseCase = fetchScheduleUseCase
        self.onLoanPaymentTap = onLoanPaymentTap
        self.onMortgageLoanPaymentTap = onMortgageLoanPaymentTap
        self.onLoanOrderTap = onLoanOrderTap
        self.onLoanRequestTap = onLoanRequestTap
        self.onEarlyLoanPaymentTap = onEarlyLoanPaymentTap
        self.onLoanScheduleTap = onLoanScheduleTap
    }

    func load() async {
        cardsState = .loading
        scheduleState = .loading
        panelState = .loading

        do {
            let fetched = try await fetchLoansUseCase.execute()
            loans = fetched

            if fetched.isEmpty {
                cardsState = .empty(title: "Kredit yoxdur", message: nil)
                scheduleState = .empty(title: "Ödəniş qrafiki yoxdur", message: nil)
                panelState = .empty(title: "Ödəniş tarixi yoxdur", message: nil)
            } else {
                cardsState = .loaded(makeCarousel(from: fetched))
                if let first = fetched.first {
                    selectedContractNumber = first.contractNumber
                    await loadSchedule(contractNumber: first.contractNumber)
                }
            }
        } catch {
            cardsState = .error(title: "Xəta", message: error.localizedDescription)
            scheduleState = .error(title: "Xəta", message: nil)
            panelState = .error(title: "Xəta", message: nil)
        }
    }

    func onLoanSelected(contractNumber: String) async {
        guard contractNumber != selectedContractNumber else { return }
        selectedContractNumber = contractNumber
        selectedFilter = .ongoing
        scheduleState = .loading
        panelState = .loading
        await loadSchedule(contractNumber: contractNumber)
    }

    func onFilterSelected(index: Int) {
        guard let filter = LoanRecordFilter(rawValue: index), filter != selectedFilter else { return }
        selectedFilter = filter
        rebuildPanel()
    }

    private func loadSchedule(contractNumber: String) async {
        do {
            let records = try await fetchScheduleUseCase.execute(contractNumber: contractNumber)
            allScheduleRecords = records
            let ongoing = records.filter { $0.isOngoing }
            scheduleState = ongoing.isEmpty
                ? .empty(title: "Ödəniş qrafiki yoxdur", message: nil)
                : .loaded(makeScheduleList(from: ongoing))
            rebuildPanel()
        } catch {
            allScheduleRecords = []
            scheduleState = .error(title: "Xəta", message: error.localizedDescription)
            panelState = .error(title: "Xəta", message: error.localizedDescription)
        }
    }

    private func rebuildPanel() {
        guard !allScheduleRecords.isEmpty else {
            panelState = .empty(title: "Ödəniş tarixi yoxdur", message: nil)
            return
        }
        panelState = .loaded(makePanel(from: filteredRecords()))
    }

    private func filteredRecords() -> [HomeLoanScheduleRecord] {
        switch selectedFilter {
        case .ongoing:
            return allScheduleRecords.filter(\.isOngoing)
        case .paid:
            return allScheduleRecords.filter { !$0.isOngoing }
        }
    }

    // MARK: - Computed UI Models

    var homeModel: RBHomeFlowLoanHomeModel {
        RBHomeFlowLoanHomeModel(
            cardsState: cardsState,
            actionsState: .loaded(homeQuickActions),
            scheduleState: scheduleState,
            panelState: panelState
        )
    }

    var detailModel: RBHomeFlowLoanDetailModel {
        let title = selectedLoan?.accountName ?? "Kredit"
        return RBHomeFlowLoanDetailModel(
            title: title,
            cardsState: cardsState,
            scheduleState: scheduleState,
            actionsState: .loaded(loanServiceActions),
            panelState: panelState
        )
    }

    private var selectedLoan: HomeLoan? {
        loans.first { $0.contractNumber == selectedContractNumber } ?? loans.first
    }

    private func handleLoanPaymentTap() {
        guard let selectedLoan else { return }
        if selectedLoan.isMortgage {
            onMortgageLoanPaymentTap(selectedLoan.birthDate, selectedLoan.mortgageID)
        } else {
            onLoanPaymentTap(selectedLoan.contractNumber)
        }
    }

    private func handleEarlyLoanPaymentTap() {
        guard let selectedLoan else { return }
        onEarlyLoanPaymentTap(selectedLoan.contractNumber)
    }

    private func handleLoanScheduleTap() {
        guard let selectedLoan else { return }
        onLoanScheduleTap(selectedLoan.contractNumber)
    }

    // MARK: - Mappers

    private func makeCarousel(from loans: [HomeLoan]) -> RBHomeFlowCarouselModel {
        RBHomeFlowCarouselModel(items: loans.map { loan in
            RBHomeFlowCarouselItem(
                id: loan.contractNumber,
                title: loan.accountName,
                subtitle: "Qalıq borc",
                amount: HomeAmountFormatter.format(loan.amount, currency: loan.currency),
                detailCaption: loan.isMortgage ? "İpoteka" : "Kredit",
                detailInfoTitle: "Müqavilə №",
                detailInfoValue: loan.contractNumber
            )
        })
    }

    private func makeScheduleList(from records: [HomeLoanScheduleRecord]) -> RBHomeFlowInfoListModel {
        guard let next = records.first else {
            return RBHomeFlowInfoListModel(title: "Ödəniş qrafiki", items: [])
        }
        let total = next.principalDebt + next.interestDebt + next.penaltyDebt
        let dateStr = next.paymentDate.map { HomeAmountFormatter.formatDate($0) }
        let items: [RBHomeFlowInfoListItem] = [
            .init(id: "sched-next", title: "Növbəti ödəniş", subtitle: dateStr,
                  value: HomeAmountFormatter.format(total, currency: "AZN")),
            .init(id: "sched-principal", title: "Əsas borc",
                  value: HomeAmountFormatter.format(next.principalDebt, currency: "AZN")),
            .init(id: "sched-interest", title: "Faiz borcu",
                  value: HomeAmountFormatter.format(next.interestDebt, currency: "AZN")),
            .init(id: "sched-penalty", title: "Cərimə borcu",
                  value: HomeAmountFormatter.format(next.penaltyDebt, currency: "AZN"))
        ]
        return RBHomeFlowInfoListModel(title: "Ödəniş qrafiki", items: items)
    }

    private func makePanel(from records: [HomeLoanScheduleRecord]) -> RBHomeFlowPanelModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "az_AZ")
        let rowTitle = selectedFilter == .ongoing ? "Gözlənilən ödəniş" : "Ödənilmiş ödəniş"
        let rowSubtitle = selectedLoan?.accountName

        return RBHomeFlowPanelModel(
            title: "Ödəniş tarixi",
            items: records.prefix(20).enumerated().map { index, record in
                let dateString = record.paymentDate.map { dateFormatter.string(from: $0) } ?? ""
                let total = record.principalDebt + record.interestDebt + record.penaltyDebt
                return RBHomeFlowPanelItem(
                    id: "pay-\(index)",
                    date: dateString,
                    title: rowTitle,
                    subtitle: rowSubtitle,
                    amount: "-\(HomeAmountFormatter.format(total, currency: "AZN"))",
                    isCredit: false
                )
            },
            segmentedControl: .init(
                selectedIndex: selectedFilter.rawValue,
                items: [LoanRecordFilter.ongoing.title, LoanRecordFilter.paid.title],
                style: .accent,
                onSelectionChange: { [weak self] index in
                    self?.onFilterSelected(index: index)
                }
            )
        )
    }

    // MARK: - Static Actions

    private var homeQuickActions: RBHomeFlowQuickActionsModel {
        RBHomeFlowQuickActionsModel(items: [
            .init(
                id: "qa-pay-loan",
                title: "Loan payment",
                icon: .custom(.actionQuickPayment),
                onTap: { [weak self] in
                    self?.handleLoanPaymentTap()
                }
            ),
            .init(
                id: "qa-order-now",
                title: "Order new",
                icon: .custom(.actionQuickTopup),
                onTap: onLoanOrderTap
            ),
            .init(
                id: "qa-request",
                title: "Request",
                icon: .iconPaperUpload,
                onTap: onLoanRequestTap
            )
        ])
    }

    private var loanServiceActions: RBHomeFlowDetailActionsModel {
        RBHomeFlowDetailActionsModel(title: "Kredit xidmətləri", items: [
            .init(id: "svc-early", title: "Erkən ödəmə",
                  description: "Krediti müddətdən əvvəl ödə", systemImage: "checkmark.circle.fill",
                  onTap: { [weak self] in self?.handleEarlyLoanPaymentTap() }),
            .init(id: "svc-schedule", title: "Ödəniş qrafiki",
                  description: "Tam ödəniş cədvəlini gör", systemImage: "calendar",
                  onTap: { [weak self] in self?.handleLoanScheduleTap() })
        ])
    }
}
