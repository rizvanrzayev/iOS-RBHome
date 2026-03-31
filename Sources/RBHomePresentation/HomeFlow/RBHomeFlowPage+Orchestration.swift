//
//  RBHomeFlowPage+Orchestration.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 13.03.2026.
//

import SwiftUI
import RBDesignSystem

extension RBHomeFlowPage {
    private var allSegments: [RBHomeFlowSegment] {
        RBHomeFlowSegment.allCases
    }

    var fullPageContent: some View {
        GeometryReader { proxy in
            let fullHeight = proxy.size.height
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    stickyTopSection
                        .zIndex(1)
                    contentArea
                }
                .background(RBHomeFlowLayout.pageBackgroundColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

                RBHomeFlowFloatingPanel(
                    panel: currentPanel,
                    peekHeight: dynamicPeekHeight,
                    fullHeight: fullHeight,
                    collapseID: AnyHashable(panelCollapseToken),
                    isBalanceVisible: isBalanceVisible,
                    onExpandedChanged: { _ in }
                )
                .ignoresSafeArea(edges: .bottom)
            }
            .simultaneousGesture(swipeBackGesture)
            .coordinateSpace(name: "homeFlowRoot")
            .onAppear {
                swipeContainerWidth = proxy.size.width
                swipeContainerHeight = proxy.size.height
            }
            .onChange(of: proxy.size.width) { swipeContainerWidth = $0 }
            .onChange(of: proxy.size.height) { swipeContainerHeight = $0 }
            .onPreferenceChange(RBHomeFlowContentBottomKey.self) { bottomY in
                guard let bottomY else { return }
                let newHeight = max(
                    RBHomeFlowLayout.floatingPanelMinPeekHeight,
                    proxy.size.height - bottomY - RBHomeFlowLayout.floatingPanelContentGap
                )
                withAnimation(RBHomeFlowPage.transitionAnimation) {
                    dynamicPeekHeight = newHeight
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }

    var contentArea: some View {
        homePagerContainer()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(RBHomeFlowLayout.pageBackgroundColor)
            .clipped()
    }

    func homePagerContainer() -> some View {
        GeometryReader { proxy in
            let pageWidth = max(proxy.size.width, 1)

            HStack(spacing: 0) {
                ForEach(allSegments, id: \.self) { segment in
                    RBScreen(kind: .plain) {
                        VStack(alignment: .leading, spacing: RBHomeFlowLayout.sectionVerticalSpacing) {
                            segmentContent(for: segment)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(
                                    key: RBHomeFlowContentBottomKey.self,
                                    value: segment == activeSegment
                                        ? geo.frame(in: .named("homeFlowRoot")).maxY
                                        : nil
                                )
                            }
                        )
                    }
                    .rbScreenBackground(.clear)
                    .rbScreenInsets(.horizontal, value: RBHomeFlowLayout.pageHorizontalInset)
                    .rbScreenInsets(.vertical, value: RBHomeFlowLayout.pageVerticalInset)
                    .frame(width: pageWidth, alignment: .topLeading)
                    .clipped()
                }
            }
            .frame(width: pageWidth * CGFloat(allSegments.count), alignment: .leading)
            .offset(x: -CGFloat(activeSegment.rawValue) * pageWidth)
            .animation(.easeInOut(duration: 0.28), value: activeSegment)
        }
        .clipped()
    }

    @ViewBuilder
    func segmentContent(for segment: RBHomeFlowSegment) -> some View {
        let segmentPayload = payload(for: segment)
        let isActive = segment == activeSegment
        carouselSection(
            state: segmentPayload.home.cardsState,
            segment: segment,
            externalDragOffset: isActive ? carouselDragOffset : 0,
            externalPageCommit: isActive ? carouselPageCommit : nil,
            onStepChanged: { step in carouselStep = step },
            onRetry: onRetry
        )
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: RBHomeFlowLayout.sectionVerticalSpacing) {
                segmentHomeBody(segmentPayload.home)
            }
            .opacity(visualMode == .home ? 1 : 0)
            .animation(RBHomeFlowPage.transitionAnimation, value: visualMode)
            .allowsHitTesting(visualMode == .home)

            VStack(alignment: .leading, spacing: RBHomeFlowLayout.sectionVerticalSpacing) {
                segmentDetailBody(segmentPayload.detail)
            }
            .opacity(visualMode == .detail ? 1 : 0)
            .animation(RBHomeFlowPage.transitionAnimation, value: visualMode)
            .allowsHitTesting(visualMode == .detail)
        }
    }

    @ViewBuilder
    private func segmentHomeBody(_ content: RBHomeFlowSegmentHomeContent) -> some View {
        switch content {
        case .card(let m):    cardHomeBody(m)
        case .account(let m): accountHomeBody(m)
        case .credit(let m):  loanHomeBody(m)
        case .deposit(let m): depositHomeBody(m)
        }
    }

    @ViewBuilder
    private func segmentDetailBody(_ content: RBHomeFlowSegmentDetailContent) -> some View {
        switch content {
        case .card(let m):    cardDetailBody(m)
        case .account(let m): accountDetailBody(m)
        case .credit(let m):  loanDetailBody(m)
        case .deposit(let m): depositDetailBody(m)
        }
    }

    func segmentHomePanel(_ content: RBHomeFlowSegmentHomeContent) -> RBHomeFlowActivePanel {
        switch content {
        case .card(let m):    return cardHomePanel(m)
        case .account(let m): return accountHomePanel(m)
        case .credit(let m):  return loanHomePanel(m)
        case .deposit(let m): return depositHomePanel(m)
        }
    }

    func segmentDetailPanel(_ content: RBHomeFlowSegmentDetailContent) -> RBHomeFlowActivePanel {
        switch content {
        case .card(let m):    return cardDetailPanel(m)
        case .account(let m): return accountDetailPanel(m)
        case .credit(let m):  return loanDetailPanel(m)
        case .deposit(let m): return depositDetailPanel(m)
        }
    }

    func payload(for segment: RBHomeFlowSegment) -> RBHomeFlowSegmentPayload {
        data.segmentPayloads[segment] ?? .placeholder(for: segment)
    }
}

private struct RBHomeFlowContentBottomKey: PreferenceKey {
    static let defaultValue: CGFloat? = nil
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = nextValue() ?? value
    }
}


