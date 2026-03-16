import RBHomeDomain
import RBHomeData
import RBHomePresentation

public final class RBHomeDIContainer {
    public init() {}

    @MainActor
    public func makeHomeViewModel() -> HomeViewModel {
        let repository = HomeRepositoryImpl()
        let useCase = FetchHomeDataUseCaseImpl(repository: repository)
        return HomeViewModel(fetchHomeDataUseCase: useCase)
    }
}
