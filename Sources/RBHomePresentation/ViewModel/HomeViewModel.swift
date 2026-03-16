import RBDesignSystem
import RBHomeDomain

@MainActor
public final class HomeViewModel: RBBaseViewModel<RBHomeFlowPageData> {
    private let fetchHomeDataUseCase: FetchHomeDataUseCase

    public init(fetchHomeDataUseCase: FetchHomeDataUseCase) {
        self.fetchHomeDataUseCase = fetchHomeDataUseCase
    }

    public override func onAppear() {
        setLoaded(RBHomeFlowPageData.placeholder)
    }
}
