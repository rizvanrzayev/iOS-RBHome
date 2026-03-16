public protocol FetchCardsUseCase: Sendable {
    func execute() async throws -> [HomeCard]
}
