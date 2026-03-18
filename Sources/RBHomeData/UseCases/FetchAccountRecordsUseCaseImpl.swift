import RBHomeDomain

package final class FetchAccountRecordsUseCaseImpl: FetchAccountRecordsUseCase {
    private let repository: HomeAccountRepository

    package init(repository: HomeAccountRepository) {
        self.repository = repository
    }

    package func execute(accountNumber: String) async throws -> [HomeAccountRecord] {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return try await repository.fetchAccountRecords(accountNumber: accountNumber)
    }
}
