import Foundation
import RBHomeDomain

extension HomeCardNetwork {
    /// Maps backend `CardDetectionType` integer to domain network enum.
    /// 0=Maestro, 1=Mastercard, 2=Visa, 3=VisaMastercard→Visa, 4=Discover, 5/nil=None
    init(detectionType: Int?) {
        switch detectionType {
        case 0: self = .maestro
        case 1: self = .mastercard
        case 2, 3: self = .visa
        case 4: self = .discover
        default: self = .none
        }
    }
}

struct HomePlasticCardsResponseDTO: Decodable {
    let listMobileUserPlasticCard: [HomePlasticCardDTO]?
    let rechargeCards: [HomeStoredCardDTO]?
    let vatCard: HomeVATCardDTO?
    enum CodingKeys: String, CodingKey {
        case listMobileUserPlasticCard = "ListMobileUserPlasticCard"
        case rechargeCards = "RechargeCards"
        case vatCard = "VatCard"
    }
}

struct HomeVATCardDTO: Decodable {
    let balance: Double?
    let pendingBalance: Double?

    enum CodingKeys: String, CodingKey {
        case balance = "Balance"
        case pendingBalance = "PendingBalance"
    }

    func toEntity() -> HomeEDVBalance {
        HomeEDVBalance(balance: balance ?? 0, pendingBalance: pendingBalance ?? 0)
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
    let cardDetectionType: Int?
    let interestAmount: Double?
    let minimumPayment: Double?
    let monthlyDebt: Double?
    let installmentCard: Bool?

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
        case cardDetectionType = "CardDetectionType"
        case interestAmount = "InterestAmount"
        case minimumPayment = "MinimumPayment"
        case monthlyDebt = "MonthlyDebt"
        case installmentCard = "InstallmentCard"
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

        let network = HomeCardNetwork(detectionType: cardDetectionType)

        return HomeCard(
            cardIdn: cardIdn ?? 0,
            name: name ?? "",
            maskedPan: maskedPan,
            amount: amount ?? 0,
            currency: currency ?? "",
            iban: iban,
            cardType: type,
            cardNetwork: network,
            isLocked: status == 3,
            hasCashbackRule: hasCashbackRule ?? false,
            interestAmount: interestAmount,
            minimumPayment: minimumPayment,
            monthlyDebt: monthlyDebt,
            installmentCard: installmentCard ?? false
        )
    }
}
