import RBHomeDomain

package final class FetchCardsUseCaseImpl: FetchCardsUseCase {
    private let repository: HomeCardRepository

    package init(repository: HomeCardRepository) {
        self.repository = repository
    }

    package func execute() async throws -> [HomeCard] {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return try await repository.fetchCards()
    }
}
