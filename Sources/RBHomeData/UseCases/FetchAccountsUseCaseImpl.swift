import RBHomeDomain

package final class FetchAccountsUseCaseImpl: FetchAccountsUseCase {
    private let repository: HomeAccountRepository

    package init(repository: HomeAccountRepository) {
        self.repository = repository
    }

    package func execute() async throws -> [HomeAccount] {
        try await repository.fetchAccounts()
    }
}
