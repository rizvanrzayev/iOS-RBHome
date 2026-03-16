import Foundation
import RBHomeDomain

struct HomeAccountStatementResponseDTO: Decodable {
    let statement: [HomeAccountRecordDTO]?
    enum CodingKeys: String, CodingKey {
        case statement = "Statement"
    }
}

struct HomeAccountRecordDTO: Decodable {
    let operDate: String?
    let title: String?
    let amount: Double?
    let currency: String?
    let paymentSource: String?

    enum CodingKeys: String, CodingKey {
        case operDate = "OperDate"
        case title = "Title"
        case amount = "Amount"
        case currency = "Currency"
        case paymentSource = "PaymentSource"
    }

    func toEntity() -> HomeAccountRecord {
        let date = operDate.flatMap { Self.dateFormatter.date(from: $0) } ?? Date()
        let isCredit = (amount ?? 0) > 0
        return HomeAccountRecord(
            operDate: date,
            title: title ?? "",
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
