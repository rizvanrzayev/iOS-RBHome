import RBHomeDomain

struct HomeStoredCardDTO: Decodable {
    let token: String?
    let maskedPan: String?
    let bankName: String?
    let nickname: String?

    enum CodingKeys: String, CodingKey {
        case token = "Token"
        case maskedPan = "MaskedPan"
        case bankName = "BankName"
        case nickname = "Nickname"
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
            isLocked: false,
            hasCashbackRule: false
        )
    }
}
