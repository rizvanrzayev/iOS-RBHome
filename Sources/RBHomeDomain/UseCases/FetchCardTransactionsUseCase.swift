public protocol FetchCardTransactionsUseCase: Sendable {
    func execute(cardIdn: Int) async throws -> [HomeCardTransaction]
}
