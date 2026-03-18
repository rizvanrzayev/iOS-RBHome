import RBHomeDomain

package final class FetchAccountsUseCaseImpl: FetchAccountsUseCase {
    private let repository: HomeAccountRepository

    package init(repository: HomeAccountRepository) {
        self.repository = repository
    }

    package func execute() async throws -> [HomeAccount] {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return try await repository.fetchAccounts()
    }
}
