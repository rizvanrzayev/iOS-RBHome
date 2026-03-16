import RBHomeDomain

public final class FetchHomeDataUseCaseImpl: FetchHomeDataUseCase {
    private let repository: HomeRepository

    public init(repository: HomeRepository) {
        self.repository = repository
    }

    public func execute() async throws -> HomeProfile {
        try await repository.fetchHomeData()
    }
}
