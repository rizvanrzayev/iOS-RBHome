import Foundation
import RBHomeDomain

struct HomeCardTransactionsResponseDTO: Decodable {
    let list: [HomeCardTransactionDTO]?
    enum CodingKeys: String, CodingKey {
        case list = "List"
    }
}

struct HomeCardTransactionDTO: Decodable {
    let localDate: String?
    let statementDescription: String?
    let amount: Double?
    let currency: String?
    let transCondition: String?
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
        case localDate = "LocalDate"
        case statementDescription = "Description"
        case amount = "Amount"
        case currency = "Currency"
        case transCondition = "TransCondition"
        case mccInfo = "MccInfo"
    }

    func toEntity() -> HomeCardTransaction {
        let date = localDate.flatMap { Self.dateFormatter.date(from: $0) } ?? Date()
        let rawAmount = amount ?? 0
        let isCredit = rawAmount > 0
        return HomeCardTransaction(
            localDate: date,
            title: mccInfo?.groupName ?? statementDescription ?? "",
            subtitle: mccInfo?.description,
            amount: abs(rawAmount),
            currency: currency ?? "",
            isCredit: isCredit,
            iconURL: mccInfo?.iconName,
            iconColorHex: mccInfo?.iconColor
        )
    }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return f
    }()
}
