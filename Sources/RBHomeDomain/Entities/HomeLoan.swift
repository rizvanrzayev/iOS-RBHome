public struct HomeLoan: Sendable {
    public let contractNumber: String
    public let accountName: String
    public let amount: Double
    public let currency: String
    public let isMortgage: Bool
    public let mortgageID: String
    public let birthDate: String

    public init(
        contractNumber: String,
        accountName: String,
        amount: Double,
        currency: String,
        isMortgage: Bool = false,
        mortgageID: String = "",
        birthDate: String = ""
    ) {
        self.contractNumber = contractNumber
        self.accountName = accountName
        self.amount = amount
        self.currency = currency
        self.isMortgage = isMortgage
        self.mortgageID = mortgageID
        self.birthDate = birthDate
    }
}
