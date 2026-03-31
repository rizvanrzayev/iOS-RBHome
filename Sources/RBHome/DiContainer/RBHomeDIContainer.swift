import Foundation
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
        public let onPaymentsTap: (String) -> Void
        public let onSplitBillTap: (HomeCardTransactionActionPayload) -> Void
        public let onChargebackTap: (HomeCardTransactionActionPayload) -> Void
        public let onLoanPaymentTap: (String) -> Void
        public let onMortgageLoanPaymentTap: (String, String) -> Void
        public let onLoanOrderTap: () -> Void
        public let onLoanRequestTap: () -> Void
        public let onSignIBContract: () -> Void
        public let onSetSecretWord: () -> Void
        public let onLogout: () -> Void
        public let onForeignCitizenVerify: (URL) -> Void

        public init(
            apiService: APIService,
            onPaymentsTap: @escaping (String) -> Void = { _ in },
            onSplitBillTap: @escaping (HomeCardTransactionActionPayload) -> Void = { _ in },
            onChargebackTap: @escaping (HomeCardTransactionActionPayload) -> Void = { _ in },
            onLoanPaymentTap: @escaping (String) -> Void = { _ in },
            onMortgageLoanPaymentTap: @escaping (String, String) -> Void = { _, _ in },
            onLoanOrderTap: @escaping () -> Void = {},
            onLoanRequestTap: @escaping () -> Void = {},
            onSignIBContract: @escaping () -> Void = {},
            onSetSecretWord: @escaping () -> Void = {},
            onLogout: @escaping () -> Void = {},
            onForeignCitizenVerify: @escaping (URL) -> Void = { _ in }
        ) {
            self.apiService = apiService
            self.onPaymentsTap = onPaymentsTap
            self.onSplitBillTap = onSplitBillTap
            self.onChargebackTap = onChargebackTap
            self.onLoanPaymentTap = onLoanPaymentTap
            self.onMortgageLoanPaymentTap = onMortgageLoanPaymentTap
            self.onLoanOrderTap = onLoanOrderTap
            self.onLoanRequestTap = onLoanRequestTap
            self.onSignIBContract = onSignIBContract
            self.onSetSecretWord = onSetSecretWord
            self.onLogout = onLogout
            self.onForeignCitizenVerify = onForeignCitizenVerify
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
            setFavoriteCardUseCase: makeSetFavoriteCardUseCase(),
            onPaymentsTap: dependencies.onPaymentsTap,
            onSplitBillTap: dependencies.onSplitBillTap,
            onChargebackTap: dependencies.onChargebackTap
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
            fetchScheduleUseCase: makeFetchLoanScheduleUseCase(),
            onLoanPaymentTap: dependencies.onLoanPaymentTap,
            onMortgageLoanPaymentTap: dependencies.onMortgageLoanPaymentTap,
            onLoanOrderTap: dependencies.onLoanOrderTap,
            onLoanRequestTap: dependencies.onLoanRequestTap
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
            depositSegmentVM: makeDepositSegmentVM(),
            onSignIBContract: dependencies.onSignIBContract,
            onSetSecretWord: dependencies.onSetSecretWord,
            onLogout: dependencies.onLogout,
            onForeignCitizenVerify: dependencies.onForeignCitizenVerify
        )
    }
}
