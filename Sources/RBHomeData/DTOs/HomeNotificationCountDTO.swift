import RBHomeDomain

struct HomeNotificationCountDTO: Decodable {
    let unreadNotificationCount: Int?

    enum CodingKeys: String, CodingKey {
        case unreadNotificationCount = "UnreadNotificationCount"
    }

    func toEntity() -> HomeNotificationCount {
        HomeNotificationCount(unreadCount: unreadNotificationCount ?? 0)
    }
}
