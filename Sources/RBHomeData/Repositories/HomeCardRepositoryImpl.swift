import Foundation
import Common
import Domain
import Data
import Networking
import RBHomeDomain

package final class HomeCardRepositoryImpl: HomeCardRepository {
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

    package func fetchCards() async throws -> [HomeCard] {
        try await withCheckedThrowingContinuation { continuation in
            let endpoint = HomePlasticEndpoint.listCards
                .makeHomeRequest(type: HomePlasticCardsResponseDTO.self)
            dataTransferService.request(with: endpoint, on: backgroundQueue) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let response):
                    let plasticCards = response.listMobileUserPlasticCard?.map { $0.toEntity() } ?? []
                    let storedCards = response.rechargeCards?.map { $0.toEntity() } ?? []
                    continuation.resume(returning: plasticCards + storedCards)
                case .failure(let error):
                    continuation.resume(throwing: self.errorHandler.handle(error))
                }
            }
        }
    }

    package func fetchCardTransactions(cardIdn: Int) async throws -> [HomeCardTransaction] {
        try await withCheckedThrowingContinuation { continuation in
            let endpoint = HomePlasticEndpoint.listTransactions(cardIdn: cardIdn)
                .makeHomeRequest(type: HomeCardTransactionsResponseDTO.self)
            dataTransferService.request(with: endpoint, on: backgroundQueue) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let response):
                    continuation.resume(returning: response.list?.map { $0.toEntity() } ?? [])
                case .failure(let error):
                    continuation.resume(throwing: self.errorHandler.handle(error))
                }
            }
        }
    }

    package func fetchEDVBalance() async throws -> HomeEDVBalance? {
        try await withCheckedThrowingContinuation { continuation in
            let endpoint = HomePlasticEndpoint.listCards
                .makeHomeRequest(type: HomePlasticCardsResponseDTO.self)
            dataTransferService.request(with: endpoint, on: backgroundQueue) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let response):
                    continuation.resume(returning: response.vatCard?.toEntity())
                case .failure(let error):
                    continuation.resume(throwing: self.errorHandler.handle(error))
                }
            }
        }
    }

    package func setFavoriteCard(cardIdn: Int) async throws {
        try await withCheckedThrowingContinuation { continuation in
            let endpoint = HomePlasticEndpoint.setFavoriteCard(cardIdn: cardIdn)
                .makeHomeRequest(type: APIResponse<EmptyDTO>.self)
            dataTransferService.request(with: endpoint, on: backgroundQueue) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: self.errorHandler.handle(error))
                }
            }
        }
    }

    package func fetchBonusPoints(cardIdn: Int) async throws -> HomeCardBonusPoint {
        try await withCheckedThrowingContinuation { continuation in
            let endpoint = HomePlasticEndpoint.getBonusPoints(cardIdn: cardIdn)
                .makeHomeRequest(type: APIResponse<HomeBonusPointDataDTO>.self)
            dataTransferService.request(with: endpoint, on: backgroundQueue) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let response):
                    continuation.resume(returning: response.data?.toEntity() ?? HomeCardBonusPoint(totalPoint: 0, currentPoint: 0))
                case .failure(let error):
                    continuation.resume(throwing: self.errorHandler.handle(error))
                }
            }
        }
    }
}
