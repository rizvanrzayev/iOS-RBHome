public protocol FetchCardTransactionsUseCase: Sendable {
    func execute(cardIdn: Int) async throws -> [HomeCardTransaction]
    func execute(token: String) async throws -> [HomeCardTransaction]
}
