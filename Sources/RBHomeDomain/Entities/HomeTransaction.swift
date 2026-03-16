public struct HomeTransaction: Sendable {
    public let id: String
    public let amount: Double

    public init(id: String, amount: Double) {
        self.id = id
        self.amount = amount
    }
}
