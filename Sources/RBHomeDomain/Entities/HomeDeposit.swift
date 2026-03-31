public struct HomeDeposit: Sendable {
    public let accountNumber: String
    public let accountName: String
    public let iban: String
    public let amount: Double
    public let currency: String
    public let calcInterest: Double

    public init(
        accountNumber: String,
        accountName: String,
        iban: String,
        amount: Double,
        currency: String,
        calcInterest: Double
    ) {
        self.accountNumber = accountNumber
        self.accountName = accountName
        self.iban = iban
        self.amount = amount
        self.currency = currency
        self.calcInterest = calcInterest
    }
}
