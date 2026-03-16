import RBHomeDomain

public final class HomeRepositoryImpl: HomeRepository {
    public init() {}

    public func fetchHomeData() async throws -> HomeProfile {
        // TODO: Implement network call
        HomeProfile(id: "", name: "")
    }
}
