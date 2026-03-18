import RBHomeDomain

package final class FetchDepositsUseCaseImpl: FetchDepositsUseCase {
    private let repository: HomeDepositRepository

    package init(repository: HomeDepositRepository) {
        self.repository = repository
    }

    package func execute() async throws -> [HomeDeposit] {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return try await repository.fetchDeposits()
    }
}
