import Foundation
import RBHomeDomain

struct HomeCardTransactionsResponseDTO: Decodable {
    let list: [HomeCardTransactionDTO]?
    enum CodingKeys: String, CodingKey {
        case list = "List"
    }
}

struct HomeCardTransactionDTO: Decodable {
    let transactionStatus: String?
    let rechargeOrderStatus: String?
    let localDate: String?
    let statementDescription: String?
    let descriptionExtended: String?
    let amount: Double?
    let currency: String?
    let accountAmount: Double?
    let accountCurrency: String?
    let rrn: String?
    let srn: String?
    let arn: String?
    let country: String?
    let city: String?
    let mcc: String?
    let fee: Double?
    let feeCurrency: String?
    let cardIdn: Int?
    let authCode: String?
    let transCondition: String?
    let isChargebackEligible: Bool?
    let mccInfo: MccInfoDTO?

    struct MccInfoDTO: Decodable {
        let iconName: String?
        let iconColor: String?
        let groupName: String?
        let description: String?

        enum CodingKeys: String, CodingKey {
            case iconName = "MccGroupIconName"
            case iconColor = "MccCategoryIconColor"
            case groupName = "MccGroupName"
            case description = "MccDescription"
        }
    }

    enum CodingKeys: String, CodingKey {
        case transactionStatus = "TransactionStatus"
        case rechargeOrderStatus = "AzericardRechargeOrderStatus"
        case localDate = "LocalDate"
        case statementDescription = "Description"
        case descriptionExtended = "DescriptionExtended"
        case amount = "Amount"
        case currency = "Currency"
        case accountAmount = "AccountAmount"
        case accountCurrency = "AccountCurrency"
        case rrn = "Rrn"
        case srn = "Srn"
        case arn = "Arn"
        case country = "Country"
        case city = "City"
        case mcc = "Mcc"
        case fee = "Fee"
        case feeCurrency = "FeeCurrency"
        case cardIdn = "CardIdn"
        case authCode = "AuthCode"
        case transCondition = "TransCondition"
        case isChargebackEligible = "IsChargebackEligible"
        case mccInfo = "MccInfo"
    }

    func toEntity() -> HomeCardTransaction {
        let date = localDate.flatMap { Self.dateFormatter.date(from: $0) } ?? Date()
        let rawAmount = amount ?? 0
        let isCredit = rawAmount > 0
        let payload = HomeCardTransactionActionPayload(
            localDate: date,
            statementDescription: statementDescription,
            descriptionExtended: descriptionExtended,
            amount: rawAmount,
            currency: currency ?? "",
            accountAmount: accountAmount ?? abs(rawAmount),
            accountCurrency: accountCurrency ?? currency ?? "",
            rrn: rrn,
            srn: srn,
            arn: arn,
            country: country,
            city: city,
            mcc: mcc,
            cardIdn: cardIdn,
            authCode: authCode,
            transCondition: transCondition,
            fee: fee,
            feeCurrency: feeCurrency ?? accountCurrency ?? currency,
            transactionStatus: transactionStatus,
            rechargeOrderStatus: rechargeOrderStatus,
            isChargebackEligible: isChargebackEligible ?? false
        )
        return HomeCardTransaction(
            localDate: date,
            title: mccInfo?.groupName ?? statementDescription ?? "",
            subtitle: mccInfo?.description,
            amount: abs(rawAmount),
            currency: currency ?? "",
            isCredit: isCredit,
            iconURL: mccInfo?.iconName,
            iconColorHex: mccInfo?.iconColor,
            enableForSplit: canSplit(rawAmount: rawAmount),
            enableForChargeback: canChargeback(rawAmount: rawAmount),
            actionPayload: payload
        )
    }

    private func canSplit(rawAmount: Double) -> Bool {
        rechargeOrderStatus == nil && transactionStatus != "Rejected" && rawAmount <= -10
    }

    private func canChargeback(rawAmount: Double) -> Bool {
        if let isChargebackEligible {
            return isChargebackEligible
        }
        return rechargeOrderStatus == nil && rawAmount < 0
    }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return f
    }()
}
