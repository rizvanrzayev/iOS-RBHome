import Foundation
import RBHomeDomain

struct HomePlasticCardsResponseDTO: Decodable {
    let listMobileUserPlasticCard: [HomePlasticCardDTO]?
    enum CodingKeys: String, CodingKey {
        case listMobileUserPlasticCard = "ListMobileUserPlasticCard"
    }
}

struct HomePlasticCardDTO: Decodable {
    let cardIdn: Int?
    let name: String?
    let pan: String?
    let amount: Double?
    let currency: String?
    let iban: String?
    let cardType: String?
    let status: Int?
    let hasCashbackRule: Bool?

    enum CodingKeys: String, CodingKey {
        case cardIdn = "CardIdn"
        case name = "Name"
        case pan = "Pan"
        case amount = "Amount"
        case currency = "Currency"
        case iban = "Iban"
        case cardType = "CardType"
        case status = "Status"
        case hasCashbackRule = "HasCashbackRule"
    }

    func toEntity() -> HomeCard {
        let type: HomeCardType
        switch cardType {
        case "C": type = .credit
        case "D": type = .debit
        default:  type = .unknown
        }

        let maskedPan: String
        if let pan, pan.count >= 4 {
            maskedPan = "**** " + pan.suffix(4)
        } else {
            maskedPan = pan ?? ""
        }

        return HomeCard(
            cardIdn: cardIdn ?? 0,
            name: name ?? "",
            maskedPan: maskedPan,
            amount: amount ?? 0,
            currency: currency ?? "",
            iban: iban,
            cardType: type,
            isLocked: status == 3,
            hasCashbackRule: hasCashbackRule ?? false
        )
    }
}
