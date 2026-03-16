public protocol FetchLoanScheduleUseCase: Sendable {
    func execute(contractNumber: String) async throws -> [HomeLoanScheduleRecord]
}
