import Foundation

public struct HomeCardTransaction: Sendable {
    public let localDate: Date
    public let title: String
    public let subtitle: String?
    public let amount: Double
    public let currency: String
    public let isCredit: Bool
    public let iconURL: String?
    public let iconColorHex: String?
    public let enableForSplit: Bool
    public let enableForChargeback: Bool
    public let actionPayload: HomeCardTransactionActionPayload

    public init(
        localDate: Date,
        title: String,
        subtitle: String? = nil,
        amount: Double,
        currency: String,
        isCredit: Bool,
        iconURL: String? = nil,
        iconColorHex: String? = nil,
        enableForSplit: Bool = false,
        enableForChargeback: Bool = false,
        actionPayload: HomeCardTransactionActionPayload
    ) {
        self.localDate = localDate
        self.title = title
        self.subtitle = subtitle
        self.amount = amount
        self.currency = currency
        self.isCredit = isCredit
        self.iconURL = iconURL
        self.iconColorHex = iconColorHex
        self.enableForSplit = enableForSplit
        self.enableForChargeback = enableForChargeback
        self.actionPayload = actionPayload
    }
}
