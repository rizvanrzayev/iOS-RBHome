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
    public let isLocked: Bool
    public let isFavorite: Bool
    public let hasCashbackRule: Bool
    /// Accrued interest amount shown on debit cards.
    public let interestAmount: Double?
    /// Minimum payment due shown on credit cards.
    public let minimumPayment: Double?
    /// Monthly installment payment amount.
    public let monthlyDebt: Double?
    /// True when the card is an installment card.
    public let installmentCard: Bool
    /// True when the card belongs to the junior product family.
    public let isJunior: Bool
    /// True when turnover-based limit extensions are available.
    public let hasTurnover: Bool
    /// True when card opens advance-loan flow instead of credit detail.
    public let isAdvanceLoan: Bool

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
        isLocked: Bool,
        isFavorite: Bool = false,
        hasCashbackRule: Bool,
        interestAmount: Double? = nil,
        minimumPayment: Double? = nil,
        monthlyDebt: Double? = nil,
        installmentCard: Bool = false,
        isJunior: Bool = false,
        hasTurnover: Bool = false,
        isAdvanceLoan: Bool = false
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
        self.isLocked = isLocked
        self.isFavorite = isFavorite
        self.hasCashbackRule = hasCashbackRule
        self.interestAmount = interestAmount
        self.minimumPayment = minimumPayment
        self.monthlyDebt = monthlyDebt
        self.installmentCard = installmentCard
        self.isJunior = isJunior
        self.hasTurnover = hasTurnover
        self.isAdvanceLoan = isAdvanceLoan
    }
}
