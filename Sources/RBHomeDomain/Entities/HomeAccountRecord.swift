import Foundation

public struct HomeAccountRecord: Sendable {
    public let operDate: Date
    public let title: String
    public let amount: Double
    public let currency: String
    public let isCredit: Bool

    public init(
        operDate: Date,
        title: String,
        amount: Double,
        currency: String,
        isCredit: Bool
    ) {
        self.operDate = operDate
        self.title = title
        self.amount = amount
        self.currency = currency
        self.isCredit = isCredit
    }
}
