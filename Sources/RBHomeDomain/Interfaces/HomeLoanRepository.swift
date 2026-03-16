public protocol HomeLoanRepository: Sendable {
    func fetchLoans() async throws -> [HomeLoan]
    func fetchLoanSchedule(contractNumber: String) async throws -> [HomeLoanScheduleRecord]
}
