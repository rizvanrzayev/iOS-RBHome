public struct HomeEDVBalance: Sendable {
    public let balance: Double
    public let pendingBalance: Double

    public init(balance: Double, pendingBalance: Double) {
        self.balance = balance
        self.pendingBalance = pendingBalance
    }
}
