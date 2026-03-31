import Common
import Networking
import Domain
import Data
import RBHomeDomain
import RBHomeData
import RBHomePresentation

public final class RBHomeDIContainer {
    public struct Dependencies {
        public let apiService: APIService

        public init(apiService: APIService) {
            self.apiService = apiService
        }
    }

    private let dependencies: Dependencies

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Repositories

    private func makeCardRepository() -> HomeCardRepository {
        HomeCardRepositoryImpl(dataTransferService: dependencies.apiService)
    }

    private func makeAccountRepository() -> HomeAccountRepository {
        HomeAccountRepositoryImpl(dataTransferService: dependencies.apiService)
    }

    private func makeLoanRepository() -> HomeLoanRepository {
        HomeLoanRepositoryImpl(dataTransferService: dependencies.apiService)
    }

    private func makeDepositRepository() -> HomeDepositRepository {
        HomeDepositRepositoryImpl(dataTransferService: dependencies.apiService)
    }

    private func makeProfileRepository() -> HomeProfileRepository {
        HomeProfileRepositoryImpl(dataTransferService: dependencies.apiService)
    }

    // MARK: - Use Cases

    private func makeFetchCardsUseCase() -> FetchCardsUseCase {
        FetchCardsUseCaseImpl(repository: makeCardRepository())
    }

    private func makeFetchCardTransactionsUseCase() -> FetchCardTransactionsUseCase {
        FetchCardTransactionsUseCaseImpl(repository: makeCardRepository())
    }

    private func makeFetchCardBonusUseCase() -> FetchCardBonusUseCase {
        FetchCardBonusUseCaseImpl(repository: makeCardRepository())
    }

    private func makeFetchEDVBalanceUseCase() -> FetchEDVBalanceUseCase {
        FetchEDVBalanceUseCaseImpl(repository: makeCardRepository())
    }

    private func makeSetFavoriteCardUseCase() -> SetFavoriteCardUseCase {
        SetFavoriteCardUseCaseImpl(repository: makeCardRepository())
    }

    private func makeFetchAccountsUseCase() -> FetchAccountsUseCase {
        FetchAccountsUseCaseImpl(repository: makeAccountRepository())
    }

    private func makeFetchAccountRecordsUseCase() -> FetchAccountRecordsUseCase {
        FetchAccountRecordsUseCaseImpl(repository: makeAccountRepository())
    }

    private func makeFetchLoansUseCase() -> FetchLoansUseCase {
        FetchLoansUseCaseImpl(repository: makeLoanRepository())
    }

    private func makeFetchLoanScheduleUseCase() -> FetchLoanScheduleUseCase {
        FetchLoanScheduleUseCaseImpl(repository: makeLoanRepository())
    }

    private func makeFetchDepositsUseCase() -> FetchDepositsUseCase {
        FetchDepositsUseCaseImpl(repository: makeDepositRepository())
    }

    private func makeFetchHomeProfileUseCase() -> FetchHomeProfileUseCase {
        FetchHomeProfileUseCaseImpl(repository: makeProfileRepository())
    }

    // MARK: - Segment ViewModels

    @MainActor
    private func makeCardSegmentVM() -> HomeCardSegmentViewModel {
        HomeCardSegmentViewModel(
            fetchCardsUseCase: makeFetchCardsUseCase(),
            fetchTransactionsUseCase: makeFetchCardTransactionsUseCase(),
            fetchBonusUseCase: makeFetchCardBonusUseCase(),
            fetchEDVBalanceUseCase: makeFetchEDVBalanceUseCase(),
            setFavoriteCardUseCase: makeSetFavoriteCardUseCase()
        )
    }

    @MainActor
    private func makeAccountSegmentVM() -> HomeAccountSegmentViewModel {
        HomeAccountSegmentViewModel(
            fetchAccountsUseCase: makeFetchAccountsUseCase(),
            fetchRecordsUseCase: makeFetchAccountRecordsUseCase()
        )
    }

    @MainActor
    private func makeLoanSegmentVM() -> HomeLoanSegmentViewModel {
        HomeLoanSegmentViewModel(
            fetchLoansUseCase: makeFetchLoansUseCase(),
            fetchScheduleUseCase: makeFetchLoanScheduleUseCase()
        )
    }

    @MainActor
    private func makeDepositSegmentVM() -> HomeDepositSegmentViewModel {
        HomeDepositSegmentViewModel(fetchDepositsUseCase: makeFetchDepositsUseCase())
    }

    // MARK: - Main ViewModel

    @MainActor
    public func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            fetchProfileUseCase: makeFetchHomeProfileUseCase(),
            cardSegmentVM: makeCardSegmentVM(),
            accountSegmentVM: makeAccountSegmentVM(),
            loanSegmentVM: makeLoanSegmentVM(),
            depositSegmentVM: makeDepositSegmentVM()
        )
    }
}
