//
//  RBHomeFlowPanelHelpers.swift
//  RBDesignSystem
//
//  Shared helpers for HomeFlow floating panel scroll behaviour.
//

import SwiftUI
import RBDesignSystem

struct PanelScrollOffsetKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct RBScrollDisabledModifier: ViewModifier {
    let disabled: Bool

    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollDisabled(disabled)
        } else {
            content
        }
    }
}

/// Shared scroll ownership wrapper for Home floating-panel content.
/// It disables inner scrolling while the panel is collapsed and reports
/// the real top state back to `RBDraggablePanel` for drag handoff.
struct RBHomeFlowPanCoordinatedScrollView<Content: View>: View {
    let isExpanded: Bool
    let coordinateSpaceName: String
    let bottomInset: CGFloat
    let topTolerance: CGFloat
    let collapseThreshold: CGFloat
    let onPullDownAtTop: (() -> Void)?
    @ViewBuilder let content: () -> Content

    @State private var scrollOffset: CGFloat = 0

    init(
        isExpanded: Bool,
        coordinateSpaceName: String,
        bottomInset: CGFloat = 0,
        topTolerance: CGFloat = 1,
        collapseThreshold: CGFloat = RBHomeFlowLayout.floatingPanelCollapseThreshold,
        onPullDownAtTop: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isExpanded = isExpanded
        self.coordinateSpaceName = coordinateSpaceName
        self.bottomInset = bottomInset
        self.topTolerance = topTolerance
        self.collapseThreshold = collapseThreshold
        self.onPullDownAtTop = onPullDownAtTop
        self.content = content
    }

    private var isScrollAtTop: Bool {
        scrollOffset >= -topTolerance
    }

    var body: some View {
        ScrollView {
            GeometryReader { geo in
                Color.clear.preference(
                    key: PanelScrollOffsetKey.self,
                    value: geo.frame(in: .named(coordinateSpaceName)).minY
                )
            }
            .frame(height: 0)

            content()
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: bottomInset) }
        .coordinateSpace(name: coordinateSpaceName)
        .rbDraggablePanelScrollAtTop(!isExpanded || isScrollAtTop)
        .modifier(RBScrollDisabledModifier(disabled: !isExpanded))
        .onPreferenceChange(PanelScrollOffsetKey.self) { scrollOffset = $0 }
        .simultaneousGesture(contentToPanelHandoffGesture)
    }

    private var contentToPanelHandoffGesture: some Gesture {
        DragGesture(minimumDistance: 8)
            .onEnded { value in
                guard isExpanded, isScrollAtTop else { return }
                let dy = value.translation.height
                let dx = value.translation.width
                let predictedDY = value.predictedEndTranslation.height
                guard dy > 0, dy > abs(dx) else { return }
                guard dy > collapseThreshold || predictedDY > collapseThreshold * 1.5 else { return }
                onPullDownAtTop?()
            }
    }
}
