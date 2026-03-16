public protocol HomeRepository: Sendable {
    func fetchHomeData() async throws -> HomeProfile
}
