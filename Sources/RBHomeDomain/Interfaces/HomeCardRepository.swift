public protocol HomeCardRepository: Sendable {
    func fetchCards() async throws -> [HomeCard]
    func fetchCardTransactions(cardIdn: Int) async throws -> [HomeCardTransaction]
    func fetchBonusPoints(cardIdn: Int) async throws -> HomeCardBonusPoint
    func fetchEDVBalance() async throws -> HomeEDVBalance?
}
