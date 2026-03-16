import Networking
import Data

enum HomeOtherEndpoint: EndpointInterface {
    case notificationCount

    var basePath: String { "other/" }

    var path: String {
        switch self {
        case .notificationCount: return "pushNotificationCount"
        }
    }

    var method: HTTPMethodType { .get }

    var mockFileName: String? {
        switch self {
        case .notificationCount: return "home_notification_count"
        }
    }
}
