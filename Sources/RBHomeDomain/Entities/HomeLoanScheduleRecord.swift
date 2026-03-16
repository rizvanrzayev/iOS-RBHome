import Foundation

public struct HomeLoanScheduleRecord: Sendable {
    public let paymentDate: Date?
    public let principalDebt: Double
    public let penaltyDebt: Double
    public let interestDebt: Double
    public let isOngoing: Bool

    public init(
        paymentDate: Date?,
        principalDebt: Double,
        penaltyDebt: Double,
        interestDebt: Double,
        isOngoing: Bool
    ) {
        self.paymentDate = paymentDate
        self.principalDebt = principalDebt
        self.penaltyDebt = penaltyDebt
        self.interestDebt = interestDebt
        self.isOngoing = isOngoing
    }
}
