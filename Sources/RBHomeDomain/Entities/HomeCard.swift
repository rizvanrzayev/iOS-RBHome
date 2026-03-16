public enum HomeCardType: Sendable {
    case debit
    case credit
    case stored
    case unknown
}

public struct HomeCard: Sendable {
    public let cardIdn: Int
    /// Non-nil for stored (other-bank) cards; used as identifier in place of cardIdn.
    public let token: String?
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
        token: String? = nil,
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
        self.token = token
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
