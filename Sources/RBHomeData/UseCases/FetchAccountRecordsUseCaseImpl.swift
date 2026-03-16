import RBHomeDomain

package final class FetchAccountRecordsUseCaseImpl: FetchAccountRecordsUseCase {
    private let repository: HomeAccountRepository

    package init(repository: HomeAccountRepository) {
        self.repository = repository
    }

    package func execute(accountNumber: String) async throws -> [HomeAccountRecord] {
        try await repository.fetchAccountRecords(accountNumber: accountNumber)
    }
}
