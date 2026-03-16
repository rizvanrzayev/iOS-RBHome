public protocol HomeProfileRepository: Sendable {
    func fetchProfile() -> HomeProfile
    func fetchNotificationCount() async throws -> HomeNotificationCount
}
