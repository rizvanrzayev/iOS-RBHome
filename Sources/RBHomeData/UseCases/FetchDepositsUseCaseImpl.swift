import RBHomeDomain

package final class FetchDepositsUseCaseImpl: FetchDepositsUseCase {
    private let repository: HomeDepositRepository

    package init(repository: HomeDepositRepository) {
        self.repository = repository
    }

    package func execute() async throws -> [HomeDeposit] {
        return try await repository.fetchDeposits()
    }
}
