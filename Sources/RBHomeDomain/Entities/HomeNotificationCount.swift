public struct HomeNotificationCount: Sendable {
    public let unreadCount: Int

    public init(unreadCount: Int) {
        self.unreadCount = unreadCount
    }
}
