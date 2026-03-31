//
//  RBHomeFlowFloatingPanel.swift
//  RBDesignSystem
//
//  Thin HomeFlow wrapper around RBDraggablePanel.
//  Owns panel-type routing (transactions vs. actions) and the title row;
//  all gesture/height logic lives in RBDraggablePanel.
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowFloatingPanel: View {
    let panel: RBHomeFlowActivePanel
    let peekHeight: CGFloat
    let fullHeight: CGFloat
    let collapseID: AnyHashable
    let onExpandedChanged: (Bool) -> Void

    private var isActionsPanel: Bool {
        if case .actions = panel { return true }
        return false
    }

    var body: some View {
        RBDraggablePanel(
            peekHeight: peekHeight,
            fullHeight: fullHeight,
            collapseID: collapseID,
            cornerRadius: RBHomeFlowLayout.floatingPanelCornerRadius,
            collapseThreshold: RBHomeFlowLayout.floatingPanelCollapseThreshold,
            expandThreshold: RBHomeFlowLayout.floatingPanelExpandThreshold,
            animation: RBHomeFlowPage.transitionAnimation,
            onExpandedChanged: onExpandedChanged
        ) { isExpanded, collapse, expand in
            ZStack(alignment: .top) {
                switch panel {
                case .transactions(let state):
                    VStack(spacing: 0) {
                        if case .loaded(let model) = state {
                            RBHomeFlowPanelSectionHeader(model: model, expand: expand, collapse: collapse)
                        }
                        RBHomeFlowTransactionsPanelContent(
                            state: state, isExpanded: isExpanded, collapse: collapse)
                    }
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
                case .actions(let state):
                    RBHomeFlowActionsPanelContent(
                        state: state, isExpanded: isExpanded, collapse: collapse)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
                }
            }
            .animation(RBHomeFlowPage.transitionAnimation, value: isActionsPanel)
        }
    }
}
