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
