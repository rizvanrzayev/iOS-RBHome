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

    // MARK: - Carousel helpers

    var activeCarouselCurrentPage: Int {
        guard case .loaded(let model) = payload(for: activeSegment).home.cardsState,
              let selectedId,
              let index = model.items.firstIndex(where: { $0.id == selectedId })
        else { return 0 }
        return index
    }

    var activeCarouselItemCount: Int {
        guard case .loaded(let model) = payload(for: activeSegment).home.cardsState
        else { return 0 }
        return model.items.count
    }

    private func isCarouselGesture(_ value: DragGesture.Value) -> Bool {
        guard activeCarouselItemCount > 1 else { return false }
        let absH = abs(value.translation.width)
        let absV = abs(value.translation.height)
        guard absH > 0 || absV > 0 else { return false }
        guard absH > absV else { return false }
        let notOnPanel = value.startLocation.y < (swipeContainerHeight - dynamicPeekHeight)
        // Reserve left edge in detail mode for swipe-back — don't animate carousel there
        let notSwipeBackEdge = !(visualMode == .detail && value.startLocation.x <= swipeEdgeThreshold)
        return notOnPanel && notSwipeBackEdge
    }

    private func commitCarouselPage(translation: CGFloat, predicted: CGFloat) {
        guard case .loaded(let model) = payload(for: activeSegment).home.cardsState,
              model.items.count > 1 else { return }
        let current = activeCarouselCurrentPage
        let count = model.items.count
        let step = max(1, carouselStep)
        let t = translation.isFinite ? translation : 0
        let p = predicted.isFinite ? predicted : 0
        let target: Int
        if abs(t) >= step * 0.3 {
            let dir = t < 0 ? current + 1 : current - 1
            target = max(0, min(count - 1, dir))
        } else {
            let rawPredicted = CGFloat(current) - (p / step)
            let predictedPage = rawPredicted.isFinite ? Int(round(rawPredicted)) : current
            let delta = max(-1, min(1, predictedPage - current))
            target = max(0, min(count - 1, current + delta))
        }
        guard target != current else { return }
        carouselPageCommit = CarouselPageCommit(page: target)
    }

    // MARK: - Gesture

    var swipeBackGesture: some Gesture {
        DragGesture(minimumDistance: 1)
            .updating($carouselDragOffset) { value, state, _ in
                guard isCarouselGesture(value) else { return }
                state = value.translation.width.isFinite ? value.translation.width : 0
            }
            .onEnded { value in
                if isCarouselGesture(value) {
                    commitCarouselPage(
                        translation: value.translation.width,
                        predicted: value.predictedEndTranslation.width
                    )
                }
                guard visualMode == .detail else { return }
                let isHorizontal = abs(value.translation.width) > abs(value.translation.height)
                let committed = isHorizontal
                    && value.translation.width > 0
                    && value.startLocation.x <= swipeEdgeThreshold
                    && (value.translation.width > 80 || value.predictedEndTranslation.width > 200)
                if committed { handleBackTap() }
            }
    }

    private func firstId<Item>(from state: RBHomeFlowSectionState<Item>) -> String? where Item: RBHomeFlowCarouselCollection {
        guard case .loaded(let model) = state else {
            return nil
        }
        return model.carouselIDs.first
    }
}
