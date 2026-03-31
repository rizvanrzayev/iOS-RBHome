import RBHomeDomain

package final class FetchCardTransactionsUseCaseImpl: FetchCardTransactionsUseCase {
    private let repository: HomeCardRepository

    package init(repository: HomeCardRepository) {
        self.repository = repository
    }

    package func execute(cardIdn: Int) async throws -> [HomeCardTransaction] {
        return try await repository.fetchCardTransactions(cardIdn: cardIdn)
    }

    package func execute(token: String) async throws -> [HomeCardTransaction] {
        try await repository.fetchStoredCardTransactions(token: token)
    }
}
