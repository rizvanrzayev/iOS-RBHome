//
//  RBHomeFlowPage+Header.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 13.03.2026.
//

import SwiftUI
import RBDesignSystem

extension RBHomeFlowPage {
    var segmentReservedHeight: CGFloat {
        RBHomeFlowLayout.segmentReservedHeight
    }

    private var segmentVisible: Bool {
        visualMode == .home
    }

    private var segmentContainerHeight: CGFloat {
        segmentVisible ? segmentReservedHeight : 0
    }

    private var stickyHorizontalPadding: CGFloat {
        visualMode == .detail ? 0 : RBHomeFlowLayout.stickyTopHorizontalPadding
    }

    var activeDetailTitle: String {
        payload(for: activeSegment).detail.title
    }

    var stickyTopSection: some View {
        VStack(alignment: .leading, spacing: RBHomeFlowLayout.sectionVerticalSpacing) {
            headerSection

            ZStack(alignment: .top) {
                RBHomeFlowSegmentSectionView(selection: $activeSegment)
                    .offset(y: segmentVisible ? 0 : -10)
                    .allowsHitTesting(segmentVisible)
                    .accessibilityHidden(!segmentVisible)
            }
            .frame(maxWidth: .infinity, minHeight: segmentContainerHeight, maxHeight: segmentContainerHeight, alignment: .top)
            .clipped()
        }
        .padding(.horizontal, stickyHorizontalPadding)
        .padding(.top, RBHomeFlowLayout.stickyTopTopPadding)
        .padding(.bottom, RBHomeFlowLayout.stickyTopBottomPadding)
        .background(RBHomeFlowLayout.pageBackgroundColor)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.rb.separator.opacity(0.45))
                .frame(height: 1)
        }
    }

    var headerSection: some View {
        ZStack {
            headerContent
                .id(visualMode)
                .transition(headerTransition)
        }
        .frame(maxWidth: .infinity, minHeight: 40, alignment: .topLeading)
        .clipped()
        .animation(.easeInOut(duration: 0.26), value: visualMode)
    }

    @ViewBuilder
    var headerContent: some View {
        switch visualMode {
        case .home:
            rbHomeFlowSectionStateView(data.profileHeaderState, minHeight: 40) { model in
                RBHomeHeaderView(model: model)
            }

        case .detail:
            RBDetailHeaderView(
                title: activeDetailTitle,
                onBackTap: handleBackTap
            )
            .padding(.horizontal, RBHomeFlowLayout.pageHorizontalInset)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    var headerTransition: AnyTransition {
        switch visualMode {
        case .home:
            return .asymmetric(
                insertion: .move(edge: .bottom),
                removal: .move(edge: .top)
            )
        case .detail:
            return .asymmetric(
                insertion: .move(edge: .top),
                removal: .move(edge: .bottom)
            )
        }
    }
}
