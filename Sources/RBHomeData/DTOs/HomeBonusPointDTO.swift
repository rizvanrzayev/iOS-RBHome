import RBHomeDomain

struct HomeBonusPointDataDTO: Decodable {
    let totalPoint: Double?
    let currentPoint: Double?

    enum CodingKeys: String, CodingKey {
        case totalPoint = "TotalPoint"
        case currentPoint = "CurrentPoint"
    }

    func toEntity() -> HomeCardBonusPoint {
        HomeCardBonusPoint(
            totalPoint: totalPoint ?? 0,
            currentPoint: currentPoint ?? 0
        )
    }
}
