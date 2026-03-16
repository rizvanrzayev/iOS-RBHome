public protocol FetchAccountsUseCase: Sendable {
    func execute() async throws -> [HomeAccount]
}
