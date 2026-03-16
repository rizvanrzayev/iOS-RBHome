import RBHomeDomain

package final class FetchLoansUseCaseImpl: FetchLoansUseCase {
    private let repository: HomeLoanRepository

    package init(repository: HomeLoanRepository) {
        self.repository = repository
    }

    package func execute() async throws -> [HomeLoan] {
        try await repository.fetchLoans()
    }
}
