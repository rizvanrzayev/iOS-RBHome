public protocol FetchEDVBalanceUseCase: Sendable {
    func execute() async throws -> HomeEDVBalance?
}
