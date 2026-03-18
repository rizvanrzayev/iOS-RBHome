//
//  RBHomeFlowPage.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 12.03.2026.
//

import SwiftUI
import RBDesignSystem

public struct RBHomeFlowPage: View {
    static let transitionAnimationDuration: Double = 0.38
    static let transitionAnimation: Animation = .spring(response: transitionAnimationDuration, dampingFraction: 0.9)

    let data: RBHomeFlowPageData
    let mode: RBHomeFlowMode
    @Binding var selectedProductId: String?
    let onModeChange: (RBHomeFlowMode) -> Void
    let onBack: () -> Void
    let onItemFocusChange: ((String, RBHomeFlowSegment) -> Void)?

    @State var previousActiveSegmentForCache: RBHomeFlowSegment?
    @State var activeSegment: RBHomeFlowSegment
    @State var selectedProductIdCache: [RBHomeFlowSegment: String?]
    @State var visualMode: RBHomeFlowMode
    @State var detailRevealProgress: CGFloat
    @State var dynamicPeekHeight: CGFloat = RBHomeFlowLayout.floatingPanelPeekHeight
    @State var panelCollapseToken: UUID = UUID()
    @State var swipeContainerWidth: CGFloat = UIScreen.main.bounds.width

    public init(
        data: RBHomeFlowPageData,
        mode: RBHomeFlowMode,
        initialSegment: RBHomeFlowSegment = .card,
        selectedProductId: Binding<String?>,
        onModeChange: @escaping (RBHomeFlowMode) -> Void,
        onBack: @escaping () -> Void,
        onItemFocusChange: ((String, RBHomeFlowSegment) -> Void)? = nil
    ) {
        self.data = data
        self.mode = mode
        self._selectedProductId = selectedProductId
        self.onModeChange = onModeChange
        self.onBack = onBack
        self.onItemFocusChange = onItemFocusChange
        self._activeSegment = State(initialValue: initialSegment)
        self._selectedProductIdCache = State(initialValue: [:])
        self._visualMode = State(initialValue: mode)
        self._detailRevealProgress = State(initialValue: mode == .detail ? 1 : 0)
    }

    public var body: some View {
        fullPageContent
        .onAppear {
            previousActiveSegmentForCache = activeSegment
            selectedProductIdCache[activeSegment] = selectedProductId
            syncVisualStateWithMode(mode)
        }
        .onChange(of: mode) { newMode in
            handleModeChange(newMode)
        }
        .onChange(of: activeSegment) { newSegment in
            handleSegmentChange(newSegment)
        }
    }
}

extension RBHomeFlowPage {
    var currentPanel: RBHomeFlowActivePanel {
        let segmentPayload = payload(for: activeSegment)
        switch visualMode {
        case .home:   return segmentHomePanel(segmentPayload.home)
        case .detail: return segmentDetailPanel(segmentPayload.detail)
        }
    }
}
