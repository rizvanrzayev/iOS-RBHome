import RBHomeDomain

package final class FetchLoansUseCaseImpl: FetchLoansUseCase {
    private let repository: HomeLoanRepository

    package init(repository: HomeLoanRepository) {
        self.repository = repository
    }

    package func execute() async throws -> [HomeLoan] {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return try await repository.fetchLoans()
    }
}
