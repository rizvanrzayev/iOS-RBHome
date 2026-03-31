import RBHomeDomain

package final class FetchEDVBalanceUseCaseImpl: FetchEDVBalanceUseCase {
    private let repository: HomeCardRepository

    package init(repository: HomeCardRepository) {
        self.repository = repository
    }

    package func execute() async throws -> HomeEDVBalance? {
        try await repository.fetchEDVBalance()
    }
}
