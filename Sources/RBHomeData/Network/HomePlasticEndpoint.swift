import Networking
import Data

enum HomePlasticEndpoint: EndpointInterface {
    case listCards
    case listTransactions(cardIdn: Int)
    case listStoredTransactions(token: String)
    case getBonusPoints(cardIdn: Int)
    case setFavoriteCard(cardIdn: Int)

    var basePath: String { "plastic/" }

    var path: String {
        switch self {
        case .listCards:         return "listPlasticCardAccount"
        case .listTransactions:  return "listDynamicStatement"
        case .listStoredTransactions: return "listCardStorageStatement"
        case .getBonusPoints:    return "kartmaneCurrentPoint"
        case .setFavoriteCard:   return "saveFavoriteCard"
        }
    }

    var method: HTTPMethodType {
        switch self {
        case .listStoredTransactions, .setFavoriteCard: return .post
        default:               return .get
        }
    }

    var queryParameters: [String: Any] {
        switch self {
        case .listCards:
            return [:]
        case .listTransactions(let cardIdn):
            return ["CardIdn": cardIdn]
        case .listStoredTransactions:
            return [:]
        case .getBonusPoints(let cardIdn):
            return ["cardIdn": cardIdn]
        case .setFavoriteCard:
            return [:]
        }
    }

    var bodyParameters: [String: Any] {
        switch self {
        case .listStoredTransactions(let token):
            return [
                "TokenList": [["Token": token]],
                "TopCategoryIdList": []
            ]
        case .setFavoriteCard(let cardIdn):
            return ["Id": cardIdn]
        default:
            return [:]
        }
    }

    var mockFileName: String? {
        switch self {
        case .listCards:        return "home_plastic_cards"
        case .listTransactions: return "home_card_transactions"
        case .listStoredTransactions: return "home_card_transactions"
        case .getBonusPoints:   return "home_bonus_points"
        case .setFavoriteCard:  return nil
        }
    }
}
