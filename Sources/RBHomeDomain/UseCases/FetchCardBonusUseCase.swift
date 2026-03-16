public protocol FetchCardBonusUseCase: Sendable {
    func execute(cardIdn: Int) async throws -> HomeCardBonusPoint
}
