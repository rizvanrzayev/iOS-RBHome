import Foundation
import Common
import Domain
import Data
import Networking
import RBHomeDomain

package final class HomeProfileRepositoryImpl: HomeProfileRepository {
    private let dataTransferService: APIService
    private let backgroundQueue: APIDispatchQueue
    private let errorHandler: ErrorHandleService

    package init(
        dataTransferService: APIService,
        backgroundQueue: APIDispatchQueue = DispatchQueue.global(qos: .userInitiated),
        errorHandler: ErrorHandleService = ErrorHandler()
    ) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
        self.errorHandler = errorHandler
    }

    package func fetchProfile() -> HomeProfile {
        let defaults = UserDefaults.standard
        let firstName = defaults.string(forKey: "firstName") ?? ""
        let lastName = defaults.string(forKey: "lastName") ?? ""
        let photo = defaults.string(forKey: "userPhoto")
        return HomeProfile(firstName: firstName, lastName: lastName, photoBase64: photo)
    }

    package func fetchNotificationCount() async throws -> HomeNotificationCount {
        try await withCheckedThrowingContinuation { continuation in
            let endpoint = HomeOtherEndpoint.notificationCount
                .makeHomeRequest(type: HomeNotificationCountDTO.self)
            dataTransferService.request(with: endpoint, on: backgroundQueue) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let response):
                    continuation.resume(returning: response.toEntity())
                case .failure(let error):
                    continuation.resume(throwing: self.errorHandler.handle(error))
                }
            }
        }
    }
}
