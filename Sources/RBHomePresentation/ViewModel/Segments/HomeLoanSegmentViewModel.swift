import Foundation
import RBHomeDomain

@MainActor
package final class HomeLoanSegmentViewModel: ObservableObject {
    @Published var cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel> = .loading
    @Published var scheduleState: RBHomeFlowSectionState<RBHomeFlowInfoListModel> = .loading
    @Published var panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel> = .loading

    private var loans: [HomeLoan] = []
    private var selectedContractNumber: String?

    private let fetchLoansUseCase: FetchLoansUseCase
    private let fetchScheduleUseCase: FetchLoanScheduleUseCase

    package init(
        fetchLoansUseCase: FetchLoansUseCase,
        fetchScheduleUseCase: FetchLoanScheduleUseCase
    ) {
        self.fetchLoansUseCase = fetchLoansUseCase
        self.fetchScheduleUseCase = fetchScheduleUseCase
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
        scheduleState = .loading
        panelState = .loading
        await loadSchedule(contractNumber: contractNumber)
    }

    private func loadSchedule(contractNumber: String) async {
        do {
            let records = try await fetchScheduleUseCase.execute(contractNumber: contractNumber)
            let ongoing = records.filter { $0.isOngoing }
            scheduleState = ongoing.isEmpty
                ? .empty(title: "Ödəniş qrafiki yoxdur", message: nil)
                : .loaded(makeScheduleList(from: ongoing))
            panelState = records.isEmpty
                ? .empty(title: "Ödəniş tarixi yoxdur", message: nil)
                : .loaded(makePanel(from: records))
        } catch {
            scheduleState = .error(title: "Xəta", message: error.localizedDescription)
            panelState = .error(title: "Xəta", message: error.localizedDescription)
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

    // MARK: - Mappers

    private func makeCarousel(from loans: [HomeLoan]) -> RBHomeFlowCarouselModel {
        RBHomeFlowCarouselModel(items: loans.map { loan in
            RBHomeFlowCarouselItem(
                id: loan.contractNumber,
                title: loan.accountName,
                subtitle: "Qalıq borc",
                amount: HomeAmountFormatter.format(loan.amount, currency: loan.currency)
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

        return RBHomeFlowPanelModel(
            title: "Ödəniş tarixi",
            items: records.prefix(20).enumerated().map { index, record in
                let dateString = record.paymentDate.map { dateFormatter.string(from: $0) } ?? ""
                let total = record.principalDebt + record.interestDebt + record.penaltyDebt
                return RBHomeFlowPanelItem(
                    id: "pay-\(index)",
                    date: dateString,
                    title: "Aylıq ödəniş",
                    amount: "-\(HomeAmountFormatter.format(total, currency: "AZN"))",
                    isCredit: false
                )
            }
        )
    }

    // MARK: - Static Actions

    private var homeQuickActions: RBHomeFlowQuickActionsModel {
        RBHomeFlowQuickActionsModel(items: [
            .init(id: "qa-pay", title: "Ödəniş et", systemImage: "creditcard.fill", onTap: {}),
            .init(id: "qa-schedule", title: "Qrafik", systemImage: "calendar", onTap: {}),
            .init(id: "qa-history", title: "Tarix", systemImage: "clock", onTap: {}),
            .init(id: "qa-more", title: "Əlavə", systemImage: "plus.circle", onTap: {})
        ])
    }

    private var loanServiceActions: RBHomeFlowDetailActionsModel {
        RBHomeFlowDetailActionsModel(title: "Kredit xidmətləri", items: [
            .init(id: "svc-early", title: "Erkən ödəmə",
                  description: "Krediti müddətdən əvvəl ödə", systemImage: "checkmark.circle.fill", onTap: {}),
            .init(id: "svc-schedule", title: "Ödəniş qrafiki",
                  description: "Tam ödəniş cədvəlini gör", systemImage: "calendar", onTap: {}),
            .init(id: "svc-refinance", title: "Yenidən maliyyələşdirmə",
                  description: "Daha əlverişli şərtlərə keç", systemImage: "arrow.2.circlepath", onTap: {}),
            .init(id: "svc-contract", title: "Müqavilə",
                  description: "Kredit müqaviləsini yüklə", systemImage: "doc.text.fill", onTap: {})
        ])
    }
}
