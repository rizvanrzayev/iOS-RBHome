import Networking
import Data

enum HomeLoanEndpoint: EndpointInterface {
    case listLoans
    case loanSchedule(contractNumber: String)

    var basePath: String {
        switch self {
        case .listLoans:     return "accounts/"
        case .loanSchedule:  return "paymentScheduler/"
        }
    }

    var path: String {
        switch self {
        case .listLoans:     return "listAllAccounts"
        case .loanSchedule:  return "listCreditAccountScheduler"
        }
    }

    var method: HTTPMethodType { .get }

    var queryParameters: [String: Any] {
        switch self {
        case .listLoans:
            return ["accountType": "Credit"]
        case .loanSchedule(let contractNumber):
            return ["contractNumber": contractNumber]
        }
    }

    var mockFileName: String? {
        switch self {
        case .listLoans:     return "home_loans"
        case .loanSchedule:  return "home_loan_schedule"
        }
    }
}
