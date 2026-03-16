public struct HomeCardBonusPoint: Sendable {
    public let totalPoint: Double
    public let currentPoint: Double

    public init(totalPoint: Double, currentPoint: Double) {
        self.totalPoint = totalPoint
        self.currentPoint = currentPoint
    }
}
