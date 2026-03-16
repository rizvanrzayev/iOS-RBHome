//
//  RBHomeFlowActionsPanelContent.swift
//  RBDesignSystem
//
//  Standalone content view for the actions variant of the HomeFlow floating panel.
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowActionsPanelContent: View {
    let state: RBHomeFlowSectionState<RBHomeFlowDetailActionsModel>
    let isExpanded: Bool
    let collapse: () -> Void

    var body: some View {
        switch state {
        case .loading:
            RBLoadingView(size: 56, isFullscreen: false)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded(let model):
            ScrollView {
                GeometryReader { geo in
                    Color.clear.preference(
                        key: PanelScrollOffsetKey.self,
                        value: geo.frame(in: .named("panelActionsScroll")).minY
                    )
                }
                .frame(height: 0)
                RBHomeFlowDetailActionListSectionView(model: .init(items: model.items))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
            }
            .coordinateSpace(name: "panelActionsScroll")
            .onPreferenceChange(PanelScrollOffsetKey.self) { offset in
                if isExpanded && offset > RBHomeFlowLayout.floatingPanelCollapseThreshold {
                    collapse()
                }
            }
            .modifier(RBScrollDisabledModifier(disabled: !isExpanded))
        case .empty(let title, let message):
            RBEmptyState(title: title, message: message, layout: .inline)
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
        case .error(let title, let message):
            RBEmptyState(title: title, message: message, layout: .inline)
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
        case .hidden:
            EmptyView()
        }
    }
}
