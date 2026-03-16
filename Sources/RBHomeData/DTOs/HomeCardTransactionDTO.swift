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

    enum CodingKeys: String, CodingKey {
        case localDate = "LocalDate"
        case statementDescription = "Description"
        case amount = "Amount"
        case currency = "Currency"
        case transCondition = "TransCondition"
    }

    func toEntity() -> HomeCardTransaction {
        let date = localDate.flatMap { Self.dateFormatter.date(from: $0) } ?? Date()
        let isCredit = transCondition == "C"
        return HomeCardTransaction(
            localDate: date,
            title: statementDescription ?? "",
            amount: abs(amount ?? 0),
            currency: currency ?? "",
            isCredit: isCredit
        )
    }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return f
    }()
}
