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
        public let onCardToCardTap: (Int) -> Void
        public let onTopupTap: (Int) -> Void
        public let onCardApplePayTap: (Int, String, Int) -> Void
        public let onCardDigitalSkinTap: (Int, String, Int) -> Void
        public let onCardRemoveTap: (String) -> Void
        public let onBonusTap: (Int, String, String) -> Void
        public let onEDVTap: () -> Void
        public let onPaymentsTap: (String) -> Void
        public let onTransferTap: () -> Void
        public let onAccountRenameTap: (String, String, String?, String?, @escaping (String) -> Void) -> Void
        public let onAccountRequisitesTap: (String, String) -> Void
        public let onAccountDocumentsTap: () -> Void
        public let onCreditCardPaymentTap: (String) -> Void
        public let onInstallmentStatementTap: (Int) -> Void
        public let onCardBlockToggleTap: (Int, Bool) -> Void
        public let onCardLimitManagementTap: (Int, String) -> Void
        public let onCardRequisitesTap: (String, String) -> Void
        public let onCardDocumentsTap: () -> Void
        public let onCardDetailSectionTap: (HomeCardDetailSectionContext) -> Void
        public let onSplitBillTap: (HomeCardTransactionActionPayload) -> Void
        public let onChargebackTap: (HomeCardTransactionActionPayload) -> Void
        public let onLoanPaymentTap: (String) -> Void
        public let onMortgageLoanPaymentTap: (String, String) -> Void
        public let onLoanOrderTap: () -> Void
        public let onLoanRequestTap: () -> Void
        public let onEarlyLoanPaymentTap: (String) -> Void
        public let onLoanScheduleTap: (String) -> Void
        public let onSignIBContract: () -> Void
        public let onSetSecretWord: () -> Void
        public let onLogout: () -> Void
        public let onForeignCitizenVerify: (URL) -> Void

        public init(
            apiService: APIService,
            onCardToCardTap: @escaping (Int) -> Void = { _ in },
            onTopupTap: @escaping (Int) -> Void = { _ in },
            onCardApplePayTap: @escaping (Int, String, Int) -> Void = { _, _, _ in },
            onCardDigitalSkinTap: @escaping (Int, String, Int) -> Void = { _, _, _ in },
            onCardRemoveTap: @escaping (String) -> Void = { _ in },
            onBonusTap: @escaping (Int, String, String) -> Void = { _, _, _ in },
            onEDVTap: @escaping () -> Void = {},
            onPaymentsTap: @escaping (String) -> Void = { _ in },
            onTransferTap: @escaping () -> Void = {},
            onAccountRenameTap: @escaping (String, String, String?, String?, @escaping (String) -> Void) -> Void = { _, _, _, _, _ in },
            onAccountRequisitesTap: @escaping (String, String) -> Void = { _, _ in },
            onAccountDocumentsTap: @escaping () -> Void = {},
            onCreditCardPaymentTap: @escaping (String) -> Void = { _ in },
            onInstallmentStatementTap: @escaping (Int) -> Void = { _ in },
            onCardBlockToggleTap: @escaping (Int, Bool) -> Void = { _, _ in },
            onCardLimitManagementTap: @escaping (Int, String) -> Void = { _, _ in },
            onCardRequisitesTap: @escaping (String, String) -> Void = { _, _ in },
            onCardDocumentsTap: @escaping () -> Void = {},
            onCardDetailSectionTap: @escaping (HomeCardDetailSectionContext) -> Void = { _ in },
            onSplitBillTap: @escaping (HomeCardTransactionActionPayload) -> Void = { _ in },
            onChargebackTap: @escaping (HomeCardTransactionActionPayload) -> Void = { _ in },
            onLoanPaymentTap: @escaping (String) -> Void = { _ in },
            onMortgageLoanPaymentTap: @escaping (String, String) -> Void = { _, _ in },
            onLoanOrderTap: @escaping () -> Void = {},
            onLoanRequestTap: @escaping () -> Void = {},
            onEarlyLoanPaymentTap: @escaping (String) -> Void = { _ in },
            onLoanScheduleTap: @escaping (String) -> Void = { _ in },
            onSignIBContract: @escaping () -> Void = {},
            onSetSecretWord: @escaping () -> Void = {},
            onLogout: @escaping () -> Void = {},
            onForeignCitizenVerify: @escaping (URL) -> Void = { _ in }
        ) {
            self.apiService = apiService
            self.onCardToCardTap = onCardToCardTap
            self.onTopupTap = onTopupTap
            self.onCardApplePayTap = onCardApplePayTap
            self.onCardDigitalSkinTap = onCardDigitalSkinTap
            self.onCardRemoveTap = onCardRemoveTap
            self.onBonusTap = onBonusTap
            self.onEDVTap = onEDVTap
            self.onPaymentsTap = onPaymentsTap
            self.onTransferTap = onTransferTap
            self.onAccountRenameTap = onAccountRenameTap
            self.onAccountRequisitesTap = onAccountRequisitesTap
            self.onAccountDocumentsTap = onAccountDocumentsTap
            self.onCreditCardPaymentTap = onCreditCardPaymentTap
            self.onInstallmentStatementTap = onInstallmentStatementTap
            self.onCardBlockToggleTap = onCardBlockToggleTap
            self.onCardLimitManagementTap = onCardLimitManagementTap
            self.onCardRequisitesTap = onCardRequisitesTap
            self.onCardDocumentsTap = onCardDocumentsTap
            self.onCardDetailSectionTap = onCardDetailSectionTap
            self.onSplitBillTap = onSplitBillTap
            self.onChargebackTap = onChargebackTap
            self.onLoanPaymentTap = onLoanPaymentTap
            self.onMortgageLoanPaymentTap = onMortgageLoanPaymentTap
            self.onLoanOrderTap = onLoanOrderTap
            self.onLoanRequestTap = onLoanRequestTap
            self.onEarlyLoanPaymentTap = onEarlyLoanPaymentTap
            self.onLoanScheduleTap = onLoanScheduleTap
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
            onCardToCardTap: dependencies.onCardToCardTap,
            onTopupTap: dependencies.onTopupTap,
            onCardApplePayTap: dependencies.onCardApplePayTap,
            onCardDigitalSkinTap: dependencies.onCardDigitalSkinTap,
            onCardRemoveTap: dependencies.onCardRemoveTap,
            onBonusTap: dependencies.onBonusTap,
            onEDVTap: dependencies.onEDVTap,
            onPaymentsTap: dependencies.onPaymentsTap,
            onCreditCardPaymentTap: dependencies.onCreditCardPaymentTap,
            onInstallmentStatementTap: dependencies.onInstallmentStatementTap,
            onCardBlockToggleTap: dependencies.onCardBlockToggleTap,
            onCardLimitManagementTap: dependencies.onCardLimitManagementTap,
            onCardRequisitesTap: dependencies.onCardRequisitesTap,
            onCardDocumentsTap: dependencies.onCardDocumentsTap,
            onCardDetailSectionTap: dependencies.onCardDetailSectionTap,
            onSplitBillTap: dependencies.onSplitBillTap,
            onChargebackTap: dependencies.onChargebackTap
        )
    }

    @MainActor
    private func makeAccountSegmentVM() -> HomeAccountSegmentViewModel {
        HomeAccountSegmentViewModel(
            fetchAccountsUseCase: makeFetchAccountsUseCase(),
            fetchRecordsUseCase: makeFetchAccountRecordsUseCase(),
            onPaymentsTap: dependencies.onPaymentsTap,
            onTransferTap: dependencies.onTransferTap,
            onAccountRenameTap: dependencies.onAccountRenameTap,
            onAccountRequisitesTap: dependencies.onAccountRequisitesTap,
            onAccountDocumentsTap: dependencies.onAccountDocumentsTap
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
            onLoanRequestTap: dependencies.onLoanRequestTap,
            onEarlyLoanPaymentTap: dependencies.onEarlyLoanPaymentTap,
            onLoanScheduleTap: dependencies.onLoanScheduleTap
        )
    }

    @MainActor
    private func makeDepositSegmentVM() -> HomeDepositSegmentViewModel {
        HomeDepositSegmentViewModel(
            fetchDepositsUseCase: makeFetchDepositsUseCase(),
            onPaymentsTap: dependencies.onPaymentsTap,
            onTransferTap: dependencies.onTransferTap
        )
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
