public struct HomeProfileData: Sendable {
    public let profile: HomeProfile
    public let notificationCount: HomeNotificationCount

    public init(profile: HomeProfile, notificationCount: HomeNotificationCount) {
        self.profile = profile
        self.notificationCount = notificationCount
    }
}

public protocol FetchHomeProfileUseCase: Sendable {
    func execute() async throws -> HomeProfileData
}
