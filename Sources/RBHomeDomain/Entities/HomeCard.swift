public enum HomeCardType: Sendable {
    case debit
    case credit
    case stored
    case unknown
}

public enum HomeCardNetwork: Sendable {
    case visa
    case mastercard
    case maestro
    case discover
    case none
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
    public let cardNetwork: HomeCardNetwork
    public let isPremium: Bool
    /// Raw card product string from API (e.g. "GamerCard", "KartmaneJunior").
    public let cardProduct: String?
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
        cardNetwork: HomeCardNetwork = .none,
        isPremium: Bool = false,
        cardProduct: String? = nil,
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
        self.cardNetwork = cardNetwork
        self.isPremium = isPremium
        self.cardProduct = cardProduct
        self.isLocked = isLocked
        self.hasCashbackRule = hasCashbackRule
    }
}
