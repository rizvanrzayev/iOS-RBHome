import Foundation

public struct HomeCardTransaction: Sendable {
    public let localDate: Date
    public let title: String
    public let amount: Double
    public let currency: String
    public let isCredit: Bool

    public init(
        localDate: Date,
        title: String,
        amount: Double,
        currency: String,
        isCredit: Bool
    ) {
        self.localDate = localDate
        self.title = title
        self.amount = amount
        self.currency = currency
        self.isCredit = isCredit
    }
}
