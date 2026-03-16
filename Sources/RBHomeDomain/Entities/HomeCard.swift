public enum HomeCardType: Sendable {
    case debit
    case credit
    case unknown
}

public struct HomeCard: Sendable {
    public let cardIdn: Int
    public let name: String
    public let maskedPan: String
    public let amount: Double
    public let currency: String
    public let iban: String?
    public let cardType: HomeCardType
    public let isLocked: Bool
    public let hasCashbackRule: Bool

    public init(
        cardIdn: Int,
        name: String,
        maskedPan: String,
        amount: Double,
        currency: String,
        iban: String?,
        cardType: HomeCardType,
        isLocked: Bool,
        hasCashbackRule: Bool
    ) {
        self.cardIdn = cardIdn
        self.name = name
        self.maskedPan = maskedPan
        self.amount = amount
        self.currency = currency
        self.iban = iban
        self.cardType = cardType
        self.isLocked = isLocked
        self.hasCashbackRule = hasCashbackRule
    }
}
