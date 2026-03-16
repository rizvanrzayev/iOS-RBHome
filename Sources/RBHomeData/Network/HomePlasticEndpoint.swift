import Networking
import Data

enum HomePlasticEndpoint: EndpointInterface {
    case listCards
    case listTransactions(cardIdn: Int)
    case getBonusPoints(cardIdn: Int)

    var basePath: String { "plastic/" }

    var path: String {
        switch self {
        case .listCards:         return "listPlasticCardAccount"
        case .listTransactions:  return "listDynamicStatement"
        case .getBonusPoints:    return "kartmaneCurrentPoint"
        }
    }

    var method: HTTPMethodType { .get }

    var queryParameters: [String: Any] {
        switch self {
        case .listCards:
            return [:]
        case .listTransactions(let cardIdn):
            return ["CardIdn": cardIdn]
        case .getBonusPoints(let cardIdn):
            return ["cardIdn": cardIdn]
        }
    }

    var mockFileName: String? {
        switch self {
        case .listCards:        return "home_plastic_cards"
        case .listTransactions: return "home_card_transactions"
        case .getBonusPoints:   return "home_bonus_points"
        }
    }
}
