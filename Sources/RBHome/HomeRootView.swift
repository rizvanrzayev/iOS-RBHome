import SwiftUI
import RBDesignSystem
import RBHomePresentation

public struct HomeRootView: View {
    @StateObject private var viewModel: HomeViewModel
    private let onClose: () -> Void

    public init(
        diContainer: RBHomeDIContainer,
        onClose: @escaping () -> Void = {}
    ) {
        _viewModel = StateObject(wrappedValue: diContainer.makeHomeViewModel())
        self.onClose = onClose
    }

    public var body: some View {
        RBAppRoot {
            HomeContentView(viewModel: viewModel)
                .onAppear { viewModel.onAppear() }
        }
    }
}

private struct HomeContentView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject private var overlayManager: RBOverlayManager

    @State private var mode: RBHomeFlowMode = .home
    @State private var selectedProductId: String?

    var body: some View {
        contentView
            .onChange(of: viewModel.onboardingModal) { modal in
                guard let modal else { return }
                presentOnboardingModal(modal, overlayManager: overlayManager, viewModel: viewModel)
            }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .loaded(let data):
            RBHomeFlowPage(
                data: data,
                mode: mode,
                selectedProductId: $selectedProductId,
                onModeChange: { mode = $0 },
                onBack: { mode = .home },
                onItemFocusChange: { id, segment in
                    viewModel.onItemFocusChanged(id: id, segment: segment)
                },
                onRetry: { viewModel.reloadSegments() },
                onFavoriteTap: { id in
                    viewModel.cardSegmentVM.toggleFavorite(cardId: id)
                }
            )
        case .loading:
            RBLoadingView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .empty(let model):
            RBEmptyState(
                title: model.title,
                message: model.message,
                icon: nil,
                layout: .fullScreen,
                actions: []
            )
        case .error(let model):
            RBEmptyState(
                title: model.title,
                message: model.message,
                icon: nil,
                layout: .fullScreen,
                actions: model.actionTitle.map { title in
                    [.init(title: title, style: .primary) { model.onAction?() ?? viewModel.retry() }]
                } ?? []
            )
        case .idle:
            Color.clear
        }
    }
}

@MainActor
private func presentOnboardingModal(
    _ modal: HomeOnboardingModal,
    overlayManager: RBOverlayManager,
    viewModel: HomeViewModel
) {
    switch modal {
    case .internetBankingContract:
        overlayManager.showAlert(.init(
            style: .info,
            title: "İnternet Banking müqaviləsi",
            message: "İnternet Banking müqaviləsini imzalamanız tələb olunur.",
            actions: [
                .init(title: "İmzala", kind: .primary) { viewModel.dismissIBContractModal(signNow: true) },
                .init(title: "Sonra", kind: .secondary) { viewModel.dismissIBContractModal(signNow: false) }
            ],
            dismissStyle: .actionsOnly,
            backgroundDismiss: false
        ))
    case .secretWord:
        overlayManager.showAlert(.init(
            style: .warning,
            title: "Gizli söz",
            message: "Hesabınızın təhlükəsizliyi üçün gizli söz təyin edin.",
            actions: [
                .init(title: "Təyin et", kind: .primary) { viewModel.dismissSecretWordModal(setNow: true) },
                .init(title: "Ləğv et", kind: .secondary) { viewModel.dismissSecretWordModal(setNow: false) }
            ],
            dismissStyle: .actionsOnly,
            backgroundDismiss: true
        ))
    case .foreignCitizen(let url):
        overlayManager.showAlert(.init(
            style: .warning,
            title: "Şəxsiyyətin təsdiqi",
            message: "Xidmətdən istifadə üçün şəxsiyyətinizi təsdiq etməlisiniz.",
            actions: [
                .init(title: "Doğrula", kind: .primary) {
                    viewModel.dismissForeignCitizenModal(verify: true, verifyURL: url)
                }
            ],
            dismissStyle: .closeButton(title: nil, onPress: {
                viewModel.dismissForeignCitizenModal(verify: false, verifyURL: url)
            }),
            backgroundDismiss: false
        ))
    }
}
