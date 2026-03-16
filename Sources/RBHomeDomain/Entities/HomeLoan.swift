public struct HomeLoan: Sendable {
    public let contractNumber: String
    public let accountName: String
    public let amount: Double
    public let currency: String

    public init(
        contractNumber: String,
        accountName: String,
        amount: Double,
        currency: String
    ) {
        self.contractNumber = contractNumber
        self.accountName = accountName
        self.amount = amount
        self.currency = currency
    }
}
