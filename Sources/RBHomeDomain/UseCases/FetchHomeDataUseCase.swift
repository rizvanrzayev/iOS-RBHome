public protocol FetchHomeDataUseCase: Sendable {
    func execute() async throws -> HomeProfile
}
