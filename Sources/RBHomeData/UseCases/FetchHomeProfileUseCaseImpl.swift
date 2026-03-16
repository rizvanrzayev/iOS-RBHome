import RBHomeDomain

package final class FetchHomeProfileUseCaseImpl: FetchHomeProfileUseCase {
    private let repository: HomeProfileRepository

    package init(repository: HomeProfileRepository) {
        self.repository = repository
    }

    package func execute() async throws -> HomeProfileData {
        let profile = repository.fetchProfile()
        let notificationCount = try await repository.fetchNotificationCount()
        return HomeProfileData(profile: profile, notificationCount: notificationCount)
    }
}
