import Foundation
import Common
import Domain
import Data
import Networking
import RBHomeDomain

package final class HomeLoanRepositoryImpl: HomeLoanRepository {
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

    package func fetchLoans() async throws -> [HomeLoan] {
        try await withCheckedThrowingContinuation { continuation in
            let endpoint = HomeLoanEndpoint.listLoans
                .makeHomeRequest(type: HomeAccountListResponseDTO.self)
            dataTransferService.request(with: endpoint, on: backgroundQueue) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let response):
                    continuation.resume(returning: response.allAccountList?.map { $0.toLoan() } ?? [])
                case .failure(let error):
                    continuation.resume(throwing: self.errorHandler.handle(error))
                }
            }
        }
    }

    package func fetchLoanSchedule(contractNumber: String) async throws -> [HomeLoanScheduleRecord] {
        try await withCheckedThrowingContinuation { continuation in
            let endpoint = HomeLoanEndpoint.loanSchedule(contractNumber: contractNumber)
                .makeHomeRequest(type: HomeLoanScheduleResponseDTO.self)
            dataTransferService.request(with: endpoint, on: backgroundQueue) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let response):
                    continuation.resume(returning: response.creditAccountScheduleList?.map { $0.toEntity() } ?? [])
                case .failure(let error):
                    continuation.resume(throwing: self.errorHandler.handle(error))
                }
            }
        }
    }
}
