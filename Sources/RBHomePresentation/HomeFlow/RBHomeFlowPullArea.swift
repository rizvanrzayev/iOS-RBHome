//
//  RBHomeFlowPullArea.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 13.03.2026.
//

import SwiftUI
import RBDesignSystem

/// Wraps content with pull-to-refresh gesture logic.
/// Pull state lives here so RBHomeFlowPage never re-renders during the gesture.
struct RBHomeFlowPullArea<Content: View>: View {
    let isEnabled: Bool
    let onRefresh: ((@escaping () -> Void) -> Void)?
    let content: Content

    init(
        isEnabled: Bool,
        onRefresh: ((@escaping () -> Void) -> Void)?,
        @ViewBuilder content: () -> Content
    ) {
        self.isEnabled = isEnabled
        self.onRefresh = onRefresh
        self.content = content()
    }

    @State private var pullOffset: CGFloat = 0
    @State private var isRefreshing: Bool = false
    @State private var hasTriggeredThresholdHaptic: Bool = false

    private let pullThreshold: CGFloat = 72
    private let refreshingOffset: CGFloat = 56

    var body: some View {
        ZStack(alignment: .top) {
            ZStack {
                RBHomeFlowLayout.pageBackgroundColor
                if isRefreshing {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color.rb.primary)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: max(0, pullOffset))

            content
                .offset(y: pullOffset)
                .allowsHitTesting(pullOffset == 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .simultaneousGesture(pullGesture)
    }

    private var pullGesture: some Gesture {
        DragGesture(minimumDistance: 8)
            .onChanged { value in
                guard isEnabled, !isRefreshing, onRefresh != nil else { return }
                let dy = value.translation.height
                let dx = value.translation.width
                guard dy > 0, dy > abs(dx) * 1.5 else {
                    if pullOffset > 0 { pullOffset = 0 }
                    return
                }
                pullOffset = min(dy * 0.42, pullThreshold + 16)
                if !hasTriggeredThresholdHaptic && pullOffset >= pullThreshold {
                    RBHaptic.trigger(.medium)
                    hasTriggeredThresholdHaptic = true
                }
            }
            .onEnded { _ in
                hasTriggeredThresholdHaptic = false
                if pullOffset >= pullThreshold {
                    triggerRefresh()
                } else {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        pullOffset = 0
                    }
                }
            }
    }

    private func triggerRefresh() {
        withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
            pullOffset = refreshingOffset
            isRefreshing = true
        }
        onRefresh? {
            withAnimation(.spring(response: 0.38, dampingFraction: 0.85)) {
                pullOffset = 0
                isRefreshing = false
            }
        }
    }
}
