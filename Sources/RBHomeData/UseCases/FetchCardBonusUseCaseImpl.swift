import RBHomeDomain

package final class FetchCardBonusUseCaseImpl: FetchCardBonusUseCase {
    private let repository: HomeCardRepository

    package init(repository: HomeCardRepository) {
        self.repository = repository
    }

    package func execute(cardIdn: Int) async throws -> HomeCardBonusPoint {
        return try await repository.fetchBonusPoints(cardIdn: cardIdn)
    }
}
