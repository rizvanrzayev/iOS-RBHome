public protocol SetFavoriteCardUseCase: Sendable {
    func execute(cardIdn: Int) async throws
}
