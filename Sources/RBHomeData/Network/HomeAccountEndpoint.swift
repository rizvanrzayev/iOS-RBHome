import Networking
import Data

enum HomeAccountEndpoint: EndpointInterface {
    case listAccounts(type: String)
    case accountStatement(accountNumber: String)

    var basePath: String { "accounts/" }

    var path: String {
        switch self {
        case .listAccounts:       return "listAllAccounts"
        case .accountStatement:   return "currentAccountStatement"
        }
    }

    var method: HTTPMethodType { .get }

    var queryParameters: [String: Any] {
        switch self {
        case .listAccounts(let type):
            return ["accountType": type]
        case .accountStatement(let accountNumber):
            return ["Account": accountNumber]
        }
    }

    var mockFileName: String? {
        switch self {
        case .listAccounts:      return "home_accounts"
        case .accountStatement:  return "home_account_statement"
        }
    }
}
