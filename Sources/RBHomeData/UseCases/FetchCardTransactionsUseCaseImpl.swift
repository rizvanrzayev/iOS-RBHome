import RBHomeDomain

package final class FetchCardTransactionsUseCaseImpl: FetchCardTransactionsUseCase {
    private let repository: HomeCardRepository

    package init(repository: HomeCardRepository) {
        self.repository = repository
    }

    package func execute(cardIdn: Int) async throws -> [HomeCardTransaction] {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return try await repository.fetchCardTransactions(cardIdn: cardIdn)
    }
}
