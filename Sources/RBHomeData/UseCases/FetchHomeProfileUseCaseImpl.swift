import RBHomeDomain

package final class FetchHomeProfileUseCaseImpl: FetchHomeProfileUseCase {
    private let repository: HomeProfileRepository

    package init(repository: HomeProfileRepository) {
        self.repository = repository
    }

    package func execute() async throws -> HomeProfileData {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        let profile = repository.fetchProfile()
        let notificationCount = try await repository.fetchNotificationCount()
        return HomeProfileData(profile: profile, notificationCount: notificationCount)
    }
}
