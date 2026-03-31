import Foundation
import Combine
import RBDesignSystem
import RBHomeDomain

@MainActor
public final class HomeViewModel: RBBaseViewModel<RBHomeFlowPageData> {
    package let cardSegmentVM: HomeCardSegmentViewModel
    package let accountSegmentVM: HomeAccountSegmentViewModel
    package let loanSegmentVM: HomeLoanSegmentViewModel
    package let depositSegmentVM: HomeDepositSegmentViewModel

    @Published public var onboardingModal: HomeOnboardingModal?

    private let fetchProfileUseCase: FetchHomeProfileUseCase
    private var profileHeaderState: RBHomeFlowSectionState<RBHomeFlowProfileHeaderModel> = .loading
    private var cancellables = Set<AnyCancellable>()

    private let onSignIBContract: () -> Void
    private let onSetSecretWord: () -> Void
    private let onLogout: () -> Void
    private let onForeignCitizenVerify: (URL) -> Void

    // package init — callers use RBHomeDIContainer.makeHomeViewModel() factory
    package init(
        fetchProfileUseCase: FetchHomeProfileUseCase,
        cardSegmentVM: HomeCardSegmentViewModel,
        accountSegmentVM: HomeAccountSegmentViewModel,
        loanSegmentVM: HomeLoanSegmentViewModel,
        depositSegmentVM: HomeDepositSegmentViewModel,
        onSignIBContract: @escaping () -> Void,
        onSetSecretWord: @escaping () -> Void,
        onLogout: @escaping () -> Void,
        onForeignCitizenVerify: @escaping (URL) -> Void
    ) {
        self.fetchProfileUseCase = fetchProfileUseCase
        self.cardSegmentVM = cardSegmentVM
        self.accountSegmentVM = accountSegmentVM
        self.loanSegmentVM = loanSegmentVM
        self.depositSegmentVM = depositSegmentVM
        self.onSignIBContract = onSignIBContract
        self.onSetSecretWord = onSetSecretWord
        self.onLogout = onLogout
        self.onForeignCitizenVerify = onForeignCitizenVerify
    }

    package func onItemFocusChanged(id: String, segment: RBHomeFlowSegment) {
        Task {
            switch segment {
            case .card:    await cardSegmentVM.onCardSelected(cardId: id)
            case .account: await accountSegmentVM.onAccountSelected(accountNumber: id)
            case .credit:  await loanSegmentVM.onLoanSelected(contractNumber: id)
            case .deposit: depositSegmentVM.onDepositSelected(accountNumber: id)
            }
        }
    }

    public func reloadSegments() {
        Task {
            async let c: Void = cardSegmentVM.load()
            async let a: Void = accountSegmentVM.load()
            async let l: Void = loanSegmentVM.load()
            async let d: Void = depositSegmentVM.load()
            _ = await (c, a, l, d)
        }
    }

    public override func onAppear() {
        bindSegmentVMs()
        rebuildPageData()
        Task {
            async let c: Void = cardSegmentVM.load()
            async let a: Void = accountSegmentVM.load()
            async let l: Void = loanSegmentVM.load()
            async let d: Void = depositSegmentVM.load()
            async let p: Void = loadProfile()
            _ = await (c, a, l, d, p)
        }
        checkOnboardingModals()
    }

    private func checkOnboardingModals() {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "userNeedIdentity") {
            let raw = defaults.string(forKey: "identificationLinkForForeignCitizen") ?? ""
            if let url = URL(string: raw) {
                onboardingModal = .foreignCitizen(verifyURL: url)
                return
            }
        }
        if defaults.bool(forKey: "rbUser"),
           !defaults.bool(forKey: "with_contract"),
           defaults.integer(forKey: "internet_banking_popup") < 3 {
            onboardingModal = .internetBankingContract
            return
        }
        if defaults.bool(forKey: "SetSecretWord") {
            onboardingModal = .secretWord
        }
    }

    public func dismissIBContractModal(signNow: Bool) {
        onboardingModal = nil
        if signNow {
            onSignIBContract()
        } else {
            let n = UserDefaults.standard.integer(forKey: "internet_banking_popup")
            UserDefaults.standard.set(n + 1, forKey: "internet_banking_popup")
        }
    }

    public func dismissSecretWordModal(setNow: Bool) {
        onboardingModal = nil
        if setNow { onSetSecretWord() }
    }

    public func dismissForeignCitizenModal(verify: Bool, verifyURL: URL) {
        onboardingModal = nil
        if verify { onForeignCitizenVerify(verifyURL) } else { onLogout() }
    }

    private func bindSegmentVMs() {
        // objectWillChange fires before property updates; schedule rebuild on next run-loop cycle
        // so rebuildPageData() sees the already-updated values.
        cardSegmentVM.objectWillChange
            .sink { [weak self] _ in
                Task { @MainActor [weak self] in self?.rebuildPageData() }
            }
            .store(in: &cancellables)

        accountSegmentVM.objectWillChange
            .sink { [weak self] _ in
                Task { @MainActor [weak self] in self?.rebuildPageData() }
            }
            .store(in: &cancellables)

        loanSegmentVM.objectWillChange
            .sink { [weak self] _ in
                Task { @MainActor [weak self] in self?.rebuildPageData() }
            }
            .store(in: &cancellables)

        depositSegmentVM.objectWillChange
            .sink { [weak self] _ in
                Task { @MainActor [weak self] in self?.rebuildPageData() }
            }
            .store(in: &cancellables)
    }

    private func loadProfile() async {
        do {
            let data = try await fetchProfileUseCase.execute()
            let profile = data.profile
            let count = data.notificationCount.unreadCount
            let notificationIcon: RBIcon = count > 0 ? .iconNotificationBadge : .iconNotification
            profileHeaderState = .loaded(RBHomeFlowProfileHeaderModel(
                avatarText: profile.initials,
                fullName: profile.fullName,
                qrAction: RBHomeFlowProfileHeaderAction(icon: .iconScan, onTap: {}),
                chatAction: RBHomeFlowProfileHeaderAction(icon: .iconChat, onTap: {}),
                notificationAction: RBHomeFlowProfileHeaderAction(icon: notificationIcon, onTap: {})
            ))
        } catch {
            let defaults = UserDefaults.standard
            let firstInitial = defaults.string(forKey: "firstName")?.first.map(String.init) ?? ""
            let lastInitial = defaults.string(forKey: "lastName")?.first.map(String.init) ?? ""
            let initials = (firstInitial + lastInitial).uppercased()
            profileHeaderState = .loaded(RBHomeFlowProfileHeaderModel(
                avatarText: initials,
                fullName: ""
            ))
        }
        rebuildPageData()
    }

    private func rebuildPageData() {
        let pageData = RBHomeFlowPageData(
            profileHeaderState: profileHeaderState,
            segmentPayloads: [
                .card: .init(
                    home: .card(cardSegmentVM.homeModel),
                    detail: .card(cardSegmentVM.detailModel)
                ),
                .account: .init(
                    home: .account(accountSegmentVM.homeModel),
                    detail: .account(accountSegmentVM.detailModel)
                ),
                .credit: .init(
                    home: .credit(loanSegmentVM.homeModel),
                    detail: .credit(loanSegmentVM.detailModel)
                ),
                .deposit: .init(
                    home: .deposit(depositSegmentVM.homeModel),
                    detail: .deposit(depositSegmentVM.detailModel)
                )
            ]
        )
        setLoaded(pageData)
    }
}
