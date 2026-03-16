import RBHomeDomain

struct HomeStoredCardDTO: Decodable {
    let token: String?
    let maskedPan: String?
    let bankName: String?
    let nickname: String?
    let cardDetectionType: Int?

    enum CodingKeys: String, CodingKey {
        case token = "Token"
        case maskedPan = "MaskedPan"
        case bankName = "BankName"
        case nickname = "Nickname"
        case cardDetectionType = "CardDetectionType"
    }

    func toEntity() -> HomeCard {
        HomeCard(
            cardIdn: 0,
            token: token,
            name: nickname ?? bankName ?? "",
            maskedPan: maskedPan ?? "",
            amount: 0,
            currency: "",
            iban: nil,
            cardType: .stored,
            cardNetwork: HomeCardNetwork(detectionType: cardDetectionType),
            isLocked: false,
            hasCashbackRule: false
        )
    }
}
