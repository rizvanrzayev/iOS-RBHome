import RBHomeDomain

package final class SetFavoriteCardUseCaseImpl: SetFavoriteCardUseCase {
    private let repository: HomeCardRepository

    package init(repository: HomeCardRepository) {
        self.repository = repository
    }

    package func execute(cardIdn: Int) async throws {
        try await repository.setFavoriteCard(cardIdn: cardIdn)
    }
}
