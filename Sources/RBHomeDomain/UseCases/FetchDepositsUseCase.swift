public protocol FetchDepositsUseCase: Sendable {
    func execute() async throws -> [HomeDeposit]
}
