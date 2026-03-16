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

    private let fetchProfileUseCase: FetchHomeProfileUseCase
    private var profileHeaderState: RBHomeFlowSectionState<RBHomeFlowProfileHeaderModel> = .loading
    private var cancellables = Set<AnyCancellable>()

    /// Pending focus-change task — cancelled when user swipes to another card before it fires.
    private var focusDebounceTask: Task<Void, Never>?

    /// Delay before triggering data load after carousel focus change.
    /// Longer on Low Power Mode to reduce background work.
    private var focusDebounceInterval: Duration {
        ProcessInfo.processInfo.isLowPowerModeEnabled ? .milliseconds(500) : .milliseconds(300)
    }

    // package init — callers use RBHomeDIContainer.makeHomeViewModel() factory
    package init(
        fetchProfileUseCase: FetchHomeProfileUseCase,
        cardSegmentVM: HomeCardSegmentViewModel,
        accountSegmentVM: HomeAccountSegmentViewModel,
        loanSegmentVM: HomeLoanSegmentViewModel,
        depositSegmentVM: HomeDepositSegmentViewModel
    ) {
        self.fetchProfileUseCase = fetchProfileUseCase
        self.cardSegmentVM = cardSegmentVM
        self.accountSegmentVM = accountSegmentVM
        self.loanSegmentVM = loanSegmentVM
        self.depositSegmentVM = depositSegmentVM
    }

    package func onItemFocusChanged(id: String, segment: RBHomeFlowSegment) {
        focusDebounceTask?.cancel()
        focusDebounceTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await Task.sleep(for: focusDebounceInterval)
            } catch {
                return // task was cancelled — user kept swiping
            }
            switch segment {
            case .card:    await cardSegmentVM.onCardSelected(cardId: id)
            case .account: await accountSegmentVM.onAccountSelected(accountNumber: id)
            case .credit:  await loanSegmentVM.onLoanSelected(contractNumber: id)
            case .deposit: depositSegmentVM.onDepositSelected(accountNumber: id)
            }
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
    }

    private func bindSegmentVMs() {
        // Merge all segment objectWillChange publishers and debounce so that rapid
        // successive state updates (e.g. bonusSummaryState + panelState set in one
        // async block) produce a single rebuildPageData() call instead of two.
        // The 16 ms window covers one display frame — imperceptible latency.
        Publishers.MergeMany(
            cardSegmentVM.objectWillChange.map { _ in () },
            accountSegmentVM.objectWillChange.map { _ in () },
            loanSegmentVM.objectWillChange.map { _ in () },
            depositSegmentVM.objectWillChange.map { _ in () }
        )
        .debounce(for: .milliseconds(16), scheduler: RunLoop.main)
        .sink { [weak self] in self?.rebuildPageData() }
        .store(in: &cancellables)
    }

    private func loadProfile() async {
        do {
            let data = try await fetchProfileUseCase.execute()
            let profile = data.profile
            let count = data.notificationCount.unreadCount
            profileHeaderState = .loaded(RBHomeFlowProfileHeaderModel(
                avatarText: profile.initials,
                fullName: profile.fullName,
                notificationAction: count > 0
                    ? RBHomeFlowProfileHeaderAction(systemImage: "bell.badge.fill", onTap: {})
                    : RBHomeFlowProfileHeaderAction(systemImage: "bell", onTap: {})
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
