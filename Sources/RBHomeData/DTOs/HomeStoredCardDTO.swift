import RBHomeDomain

struct HomeStoredCardDTO: Decodable {
    let token: String?
    let maskedPan: String?
    let fullPan: String?
    let expiryDate: String?
    let cardExpiryDate: String?
    let bankName: String?
    let nickname: String?
    let bankLogo: String?
    let cardDetectionType: Int?

    enum CodingKeys: String, CodingKey {
        case token = "Token"
        case maskedPan = "MaskedPan"
        case fullPan = "FullPan"
        case expiryDate = "ExpiryDate"
        case cardExpiryDate = "CardExpiryDate"
        case bankName = "BankName"
        case nickname = "Nickname"
        case bankLogo = "BankLogo"
        case cardDetectionType = "CardDetectionType"
    }

    func toEntity() -> HomeCard {
        HomeCard(
            cardIdn: 0,
            token: token,
            name: nickname ?? bankName ?? "",
            maskedPan: maskedPan ?? "",
            fullPan: fullPan,
            expiryDate: expiryDate ?? cardExpiryDate,
            bankLogoURL: bankLogo,
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
