public protocol FetchLoansUseCase: Sendable {
    func execute() async throws -> [HomeLoan]
}
