import Foundation
import RBHomeDomain

struct HomeLoanScheduleResponseDTO: Decodable {
    let creditAccountScheduleList: [HomeLoanScheduleDTO]?
    enum CodingKeys: String, CodingKey {
        case creditAccountScheduleList = "CreditAccountScheduleList"
    }
}

struct HomeLoanScheduleDTO: Decodable {
    let paymentDate: String?
    let ongoingPrincipialDebt: Double?
    let ongoingPenaltyDebt: Double?
    let onGoingInterestDebt: Double?
    let isOngoing: Bool?

    enum CodingKeys: String, CodingKey {
        case paymentDate = "PaymentDate"
        case ongoingPrincipialDebt = "OngoingPrincipialDebt"
        case ongoingPenaltyDebt = "OngoingPenaltyDebt"
        case onGoingInterestDebt = "OnGoingInterestDebt"
        case isOngoing = "IsOngoing"
    }

    func toEntity() -> HomeLoanScheduleRecord {
        let date = paymentDate.flatMap { Self.dateFormatter.date(from: $0) }
        return HomeLoanScheduleRecord(
            paymentDate: date,
            principalDebt: ongoingPrincipialDebt ?? 0,
            penaltyDebt: ongoingPenaltyDebt ?? 0,
            interestDebt: onGoingInterestDebt ?? 0,
            isOngoing: isOngoing ?? false
        )
    }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return f
    }()
}
