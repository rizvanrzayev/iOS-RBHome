import RBHomeDomain

package final class FetchCardsUseCaseImpl: FetchCardsUseCase {
    private let repository: HomeCardRepository

    package init(repository: HomeCardRepository) {
        self.repository = repository
    }

    package func execute() async throws -> [HomeCard] {
        return try await repository.fetchCards()
    }
}
