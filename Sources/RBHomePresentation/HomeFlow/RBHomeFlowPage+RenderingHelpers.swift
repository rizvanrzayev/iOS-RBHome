//
//  RBHomeFlowPage+RenderingHelpers.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 13.03.2026.
//

import SwiftUI
import RBDesignSystem

extension RBHomeFlowPage {
    func carouselSection(
        state: RBHomeFlowSectionState<RBHomeFlowCarouselModel>,
        segment: RBHomeFlowSegment
    ) -> some View {
        rbHomeFlowSectionStateView(state, minHeight: 162, skeleton: { RBHomeFlowCarouselSkeleton().padding(.horizontal, -RBHomeFlowLayout.pageHorizontalInset) }) { model in
            RBHomeFlowProductCarouselSectionView(
                items: model.items,
                selectedId: selectedProductId,
                detailRevealProgress: detailRevealProgress,
                onSelect: handlePrimaryItemTap,
                onFocusChange: handlePrimaryItemFocusChange,
                layout: .homeFlowDefault,
                shellStyle: { _ in .preset(segment.carouselShellPreset) },
                content: { item in carouselCardContent(item: item, segment: segment) },
                detailContent: { item in
                    RBHomeFlowCarouselDetailPanel(
                        segmentLabel: segment.title,
                        title: item.title,
                        subtitle: item.subtitle,
                        amount: item.amount
                    )
                }
            )
            .padding(.horizontal, -RBHomeFlowLayout.pageHorizontalInset)
        }
    }

    @ViewBuilder
    private func carouselCardContent(item: RBHomeFlowCarouselItem, segment: RBHomeFlowSegment) -> some View {
        switch segment {
        case .card:
            RBProductCardPlasticContent(
                model: .init(
                    amount: amountText(item.amount),
                    title: item.title,
                    maskedNumber: .init(item.subtitle),
                    brandImageName: item.networkAsset,
                    trailingIcons: .init(showsEye: false, showsFavorite: false),
                    bottomLeadingLabel: item.bottomLeadingLabel
                )
            )
        case .account, .credit, .deposit:
            RBProductCardDefaultContent(
                model: .init(
                    amount: amountText(item.amount),
                    title: item.title,
                    subtitle: item.subtitle,
                    trailingIcons: .init(showsEye: false, showsFavorite: false)
                )
            )
        }
    }

    func quickActionsSection(
        state: RBHomeFlowSectionState<RBHomeFlowQuickActionsModel>
    ) -> some View {
        rbHomeFlowSectionStateView(state, minHeight: 100, skeleton: { RBHomeFlowQuickActionsSkeleton() }) { model in
            RBHomeFlowQuickActionsSectionView(model: model)
        }
    }

    func bonusSummarySection(
        state: RBHomeFlowSectionState<RBHomeFlowBonusSummaryModel>
    ) -> some View {
        rbHomeFlowSectionStateView(state, minHeight: 76, skeleton: { RBHomeFlowBonusSummarySkeleton() }) { model in
            RBHomeFlowBonusSummarySectionView(model: model)
        }
        .frame(maxWidth: .infinity, maxHeight: 76)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
        )
        .padding(.horizontal, 12)
    }

    func detailActionListSection(
        state: RBHomeFlowSectionState<RBHomeFlowDetailActionsModel>
    ) -> some View {
        rbHomeFlowSectionStateView(state, minHeight: 180, skeleton: { RBHomeFlowDetailActionsSkeleton() }) { model in
            RBHomeFlowDetailActionListSectionView(model: model)
        }
    }

    func infoListSection(
        state: RBHomeFlowSectionState<RBHomeFlowInfoListModel>
    ) -> some View {
        rbHomeFlowSectionStateView(state, minHeight: 136, skeleton: { RBHomeFlowInfoListSkeleton() }) { model in
            RBHomeFlowInfoListSectionView(model: model)
        }
    }

    private func amountText(_ rawValue: String) -> RBProductCardAmountText {
        let parts = rawValue.split(separator: " ")
        guard parts.count > 1 else {
            return .init(primary: rawValue)
        }
        let rawSecondary = String(parts.last ?? "")
        let secondary = rawSecondary == "AZN" ? "₼" : rawSecondary
        let primary = parts.dropLast().joined(separator: " ")
        return .init(primary: primary, secondary: secondary)
    }
}
