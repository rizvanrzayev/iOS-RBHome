public struct HomeAccount: Sendable {
    public let accountNumber: String
    public let accountName: String
    public let nickname: String?
    public let iban: String
    public let amount: Double
    public let currency: String
    public let accountTypeRaw: String?

    public init(
        accountNumber: String,
        accountName: String,
        nickname: String? = nil,
        iban: String,
        amount: Double,
        currency: String,
        accountTypeRaw: String? = nil
    ) {
        self.accountNumber = accountNumber
        self.accountName = accountName
        self.nickname = nickname
        self.iban = iban
        self.amount = amount
        self.currency = currency
        self.accountTypeRaw = accountTypeRaw
    }
}
