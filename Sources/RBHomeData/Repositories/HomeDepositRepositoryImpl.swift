import Foundation
import Common
import Domain
import Data
import Networking
import RBHomeDomain

package final class HomeDepositRepositoryImpl: HomeDepositRepository {
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

    package func fetchDeposits() async throws -> [HomeDeposit] {
        try await withCheckedThrowingContinuation { continuation in
            let endpoint = HomeAccountEndpoint.listAccounts(type: "Deposit")
                .makeHomeRequest(type: HomeAccountListResponseDTO.self)
            dataTransferService.request(with: endpoint, on: backgroundQueue) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let response):
                    continuation.resume(returning: response.allAccountList?.map { $0.toDeposit() } ?? [])
                case .failure(let error):
                    continuation.resume(throwing: self.errorHandler.handle(error))
                }
            }
        }
    }
}
