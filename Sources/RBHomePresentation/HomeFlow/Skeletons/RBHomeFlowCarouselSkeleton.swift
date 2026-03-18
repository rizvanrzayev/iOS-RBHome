//
//  RBHomeFlowCarouselSkeleton.swift
//  RBHomePresentation
//

import SwiftUI
import RBDesignSystem

/// Skeleton that mirrors the compact carousel layout:
/// leading inset + main card + spacing + peeking second card + page indicator.
///
/// Internal structure intentionally matches `RBProductCardDetailCarousel` exactly:
/// outer GeometryReader with fixed frame, inner VStack without height constraint —
/// so the indicator receives the same natural size as in the loaded state.
struct RBHomeFlowCarouselSkeleton: View {
    private let height: CGFloat = RBHomeFlowLayout.detailPanelItemHeight
    private let spacing: CGFloat = RBHomeFlowLayout.detailPanelSpacing
    private let cardViewportInset: CGFloat = 2 * RBHomeFlowLayout.carouselLeadingInset

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 12) {
                let cardWidth = max(1, proxy.size.width - cardViewportInset)
                HStack(spacing: spacing) {
                    cardShell.frame(width: cardWidth, height: height)
                    cardShell.frame(width: cardWidth, height: height)
                }
                .padding(.leading, RBHomeFlowLayout.carouselLeadingInset)
                .frame(width: proxy.size.width, height: height, alignment: .leading)
                .clipped()

                RBCarouselPageIndicator(count: 3, currentIndex: 0)
            }
            .frame(width: proxy.size.width, alignment: .topLeading)
        }
        .frame(height: height + 24)
    }

    private var cardShell: some View {
        var style = RBProductCardShellStyle.preset(.plastic)
        style.aspectRatio = nil
        return RBProductCardShell(style: style) {
            RBProductCardSkeletonContent()
        }
    }
}
