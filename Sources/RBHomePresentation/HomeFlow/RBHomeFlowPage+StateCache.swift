//
//  RBHomeFlowPage+StateCache.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 13.03.2026.
//

import SwiftUI
import RBDesignSystem

extension RBHomeFlowPage {
    func handleBackTap() {
        if mode == .detail {
            onModeChange(.home)
        } else {
            onBack()
        }
    }

    func handleSegmentChange(_ newSegment: RBHomeFlowSegment) {
        let previousSegment = previousActiveSegmentForCache ?? newSegment
        if previousSegment != newSegment {
            selectedProductIdCache[previousSegment] = selectedProductId
            panelCollapseToken = UUID()
        }

        let restored = selectedProductIdCache[newSegment] ?? defaultSelectedProductId(for: newSegment)
        selectedProductId = restored
        selectedProductIdCache[newSegment] = restored
        previousActiveSegmentForCache = newSegment
    }

    private func defaultSelectedProductId(for segment: RBHomeFlowSegment) -> String? {
        guard let payload = data.segmentPayloads[segment] else {
            return nil
        }
        return firstId(from: payload.home.cardsState)
    }

    func handlePrimaryItemTap(_ id: String) {
        selectedProductId = id
        selectedProductIdCache[activeSegment] = id

        if mode == .home {
            onModeChange(.detail)
        }
    }

    func handlePrimaryItemFocusChange(_ id: String) {
        guard selectedProductId != id else {
            return
        }

        selectedProductId = id
        selectedProductIdCache[activeSegment] = id
        onItemFocusChange?(id, activeSegment)
    }

    func syncVisualStateWithMode(_ mode: RBHomeFlowMode) {
        visualMode = mode
        detailRevealProgress = mode == .detail ? 1 : 0
    }

    func handleModeChange(_ newMode: RBHomeFlowMode) {
        guard newMode != visualMode else { return }
        runTransition(to: newMode)
    }

    func runTransition(to targetMode: RBHomeFlowMode) {
        RBHaptic.trigger(.light)

        if targetMode == .home {
            panelCollapseToken = UUID()
        }

        withAnimation(RBHomeFlowPage.transitionAnimation) {
            visualMode = targetMode
            detailRevealProgress = targetMode == .detail ? 1 : 0
        }

        let hapticDelay = RBHomeFlowPage.transitionAnimationDuration * 0.85
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(hapticDelay * 1_000_000_000))
            RBHaptic.trigger(.medium)
        }
    }

    private var swipeEdgeThreshold: CGFloat { 60 }

    var swipeBackGesture: some Gesture {
        DragGesture(minimumDistance: 1)
            .onEnded { value in
                guard visualMode == .detail else { return }
                let isHorizontal = abs(value.translation.width) > abs(value.translation.height)
                let committed = isHorizontal
                    && value.translation.width > 0
                    && value.startLocation.x <= swipeEdgeThreshold
                    && (value.translation.width > 80 || value.predictedEndTranslation.width > 200)
                if committed {
                    handleBackTap()
                }
            }
    }

    private func firstId<Item>(from state: RBHomeFlowSectionState<Item>) -> String? where Item: RBHomeFlowCarouselCollection {
        guard case .loaded(let model) = state else {
            return nil
        }
        return model.carouselIDs.first
    }
}
