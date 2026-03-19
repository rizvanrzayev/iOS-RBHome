import RBHomeDomain

package final class FetchLoansUseCaseImpl: FetchLoansUseCase {
    private let repository: HomeLoanRepository

    package init(repository: HomeLoanRepository) {
        self.repository = repository
    }

    package func execute() async throws -> [HomeLoan] {
        return try await repository.fetchLoans()
    }
}
