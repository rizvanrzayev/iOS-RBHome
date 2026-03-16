//
//  RBHomeFlowCarouselSectionView.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 14.03.2026.
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowCarouselLayoutConfig {
    let aspectRatio: CGFloat
    let compactLeadingInsetDesign: CGFloat
    let compactTrailingPeekDesign: CGFloat
    let detailPanelWidthDesign: CGFloat
    let detailPanelTrailingPeek: CGFloat
    let detailPanelVisibleCardWidthDesign: CGFloat
    let detailPanelItemHeight: CGFloat
    let detailPanelSpacing: CGFloat

    static var homeFlowDefault: Self {
        .init(
            aspectRatio: RBHomeFlowLayout.carouselCardAspectRatio,
            compactLeadingInsetDesign: RBHomeFlowLayout.carouselLeadingInset,
            compactTrailingPeekDesign: RBHomeFlowLayout.carouselSidePeek,
            detailPanelWidthDesign: RBHomeFlowLayout.detailPanelWidthDesign,
            detailPanelTrailingPeek: RBHomeFlowLayout.detailPanelTrailingPeek,
            detailPanelVisibleCardWidthDesign: RBHomeFlowLayout.detailPanelVisibleCardWidthDesign,
            detailPanelItemHeight: RBHomeFlowLayout.detailPanelItemHeight,
            detailPanelSpacing: RBHomeFlowLayout.detailPanelSpacing
        )
    }
}

struct RBHomeFlowProductCarouselSectionView<Item: Identifiable, Content: View, DetailContent: View>: View where Item.ID == String {
    let items: [Item]
    let selectedId: String?
    let detailRevealProgress: CGFloat
    let onSelect: (String) -> Void
    let onFocusChange: (String) -> Void
    let layout: RBHomeFlowCarouselLayoutConfig
    let shellStyle: (Item) -> RBProductCardShellStyle
    let content: (Item) -> Content
    let detailContent: (Item) -> DetailContent

    @State private var currentPage: Int = 0
    // IDs reported via onFocusChange (internal swipe). When selectedId changes to one
    // of these, it was caused by our own swipe — skip syncCurrentPageFromSelection to
    // prevent the feedback loop that resets currentPage during rapid swiping.
    @State private var pendingFocusIds = Set<String>()

    var body: some View {
        let cardDesignWidth = layout.aspectRatio * layout.detailPanelItemHeight
        let interpolatedVisibleCard = cardDesignWidth + (layout.detailPanelVisibleCardWidthDesign - cardDesignWidth) * detailRevealProgress
        let interpolatedDetailWidth = layout.detailPanelWidthDesign * detailRevealProgress
        let interpolatedLeadingInset = layout.compactLeadingInsetDesign * (1 - detailRevealProgress)
        let interpolatedTrailingPeek = layout.compactTrailingPeekDesign + (layout.detailPanelTrailingPeek - layout.compactTrailingPeekDesign) * detailRevealProgress

        RBProductCardDetailCarousel(
            items: items,
            currentPage: $currentPage,
            itemHeight: layout.detailPanelItemHeight,
            cardDesignWidth: cardDesignWidth,
            cardViewportInset: 2 * RBHomeFlowLayout.carouselLeadingInset,
            detailDesignWidth: interpolatedDetailWidth,
            visibleCardDesignWidth: interpolatedVisibleCard,
            leadingInsetDesign: interpolatedLeadingInset,
            spacing: layout.detailPanelSpacing,
            trailingPeek: interpolatedTrailingPeek,
            scalesSpacingAndPeekWithViewport: false,
            showsIndicator: true
        ) { item in
            cardShell(for: item)
                .contentShape(Rectangle())
                .onTapGesture { onSelect(item.id) }
        } rightContent: { item in
            detailContent(item)
                .opacity(detailRevealProgress)
        }
        .onAppear { syncCurrentPageFromSelection() }
        .onChange(of: selectedId) { newValue in
            if let newValue, pendingFocusIds.remove(newValue) != nil {
                return
            }
            syncCurrentPageFromSelection()
        }
        .onChange(of: items.map(\.id)) { _ in syncCurrentPageFromSelection() }
        .onChange(of: currentPage) { newValue in
            guard items.indices.contains(newValue) else { return }
            let focusedId = items[newValue].id
            guard focusedId != selectedId else { return }
            pendingFocusIds.insert(focusedId)
            onFocusChange(focusedId)
        }
    }

    private func cardShell(for item: Item) -> some View {
        let baseStyle = shellStyle(item)
        let resolvedShellStyle = RBProductCardShellStyle(
            cornerRadius: baseStyle.cornerRadius,
            contentPadding: baseStyle.contentPadding,
            background: baseStyle.background,
            overlay: baseStyle.overlay,
            border: baseStyle.border,
            aspectRatio: nil
        )

        return RBProductCardShell(style: resolvedShellStyle) {
            content(item)
        }
    }

    private func syncCurrentPageFromSelection() {
        guard items.isEmpty == false else {
            setCurrentPageWithoutAnimation(0)
            return
        }

        guard
            let selectedId,
            let selectedIndex = items.firstIndex(where: { $0.id == selectedId })
        else {
            setCurrentPageWithoutAnimation(min(max(currentPage, 0), items.count - 1))
            return
        }

        guard selectedIndex != currentPage else { return }
        setCurrentPageWithoutAnimation(selectedIndex)
    }

    private func setCurrentPageWithoutAnimation(_ page: Int) {
        var transaction = Transaction(animation: nil)
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            currentPage = page
        }
    }
}
