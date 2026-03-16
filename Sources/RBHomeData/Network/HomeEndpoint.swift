import Networking
import Data

enum HomeEndpoint: EndpointInterface {
    case fetchHome

    var basePath: String { "home" }

    var path: String {
        switch self {
        case .fetchHome: return ""
        }
    }

    var method: HTTPMethodType { .get }

    var mockFileName: String? { nil }
}
