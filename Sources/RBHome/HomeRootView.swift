import SwiftUI
import RBDesignSystem
import RBHomePresentation

public struct HomeRootView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var mode: RBHomeFlowMode = .home
    @State private var selectedProductId: String?
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
            contentView
                .onAppear { viewModel.onAppear() }
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
                onRetry: { viewModel.reloadSegments() }
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
