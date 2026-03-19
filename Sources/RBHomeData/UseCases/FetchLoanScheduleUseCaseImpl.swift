import RBHomeDomain

package final class FetchLoanScheduleUseCaseImpl: FetchLoanScheduleUseCase {
    private let repository: HomeLoanRepository

    package init(repository: HomeLoanRepository) {
        self.repository = repository
    }

    package func execute(contractNumber: String) async throws -> [HomeLoanScheduleRecord] {
        return try await repository.fetchLoanSchedule(contractNumber: contractNumber)
    }
}
