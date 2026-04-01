//
//  RBHomeFlowPage+RenderingHelpers.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 13.03.2026.
//

import SwiftUI
import RBDesignSystem

extension RBHomeFlowPage {
    @ViewBuilder
    func carouselSection(
        state: RBHomeFlowSectionState<RBHomeFlowCarouselModel>,
        segment: RBHomeFlowSegment,
        externalDragOffset: CGFloat = 0,
        externalPageCommit: CarouselPageCommit? = nil,
        onStepChanged: ((CGFloat) -> Void)? = nil,
        onRetry: (() -> Void)? = nil
    ) -> some View {
        if case .error(let title, let message) = state {
            RBHomeFlowCarouselErrorCell(title: title, message: message, onRetry: onRetry)
        } else {
            rbHomeFlowSectionStateView(state, minHeight: 162, skeleton: { RBHomeFlowCarouselSkeleton().padding(.horizontal, -RBHomeFlowLayout.pageHorizontalInset) }) { model in
                RBHomeFlowProductCarouselSectionView(
                    items: model.items,
                    selectedId: selectedProductId,
                    detailRevealProgress: detailRevealProgress,
                    externalDragOffset: externalDragOffset,
                    externalPageCommit: externalPageCommit,
                    onSelect: handlePrimaryItemTap,
                    onFocusChange: handlePrimaryItemFocusChange,
                    onStepChanged: onStepChanged,
                    layout: .homeFlowDefault,
                    shellStyle: { item in
                        if item.isStored {
                            return .preset(.storedCard)
                        }
                        if segment == .credit {
                            return .plasticCard(assetName: "rb.card.bg.plastic.premium")
                        }
                        return .preset(segment.carouselShellPreset)
                    },
                    content: { item in carouselCardContent(item: item, segment: segment) },
                    detailContent: { item in
                        if segment == .card, let cardDetailContent = item.cardDetailContent {
                            return AnyView(
                                RBHomeFlowCardCarouselDetailView(
                                    content: cardDetailContent,
                                    amountText: isBalanceVisible ? cardDetailContent.amountText : "••••"
                                )
                            )
                        } else if segment == .account {
                            return AnyView(
                                RBHomeFlowAccountCarouselDetailPanel(
                                    caption: item.detailCaption ?? item.title,
                                    amount: isBalanceVisible ? item.amount : "••••",
                                    infoTitle: item.detailInfoTitle ?? "IBAN",
                                    infoValue: item.detailInfoValue ?? item.subtitle
                                )
                            )
                        } else {
                            return AnyView(
                                RBHomeFlowCarouselDetailPanel(
                                    segmentLabel: segment.title,
                                    title: item.title,
                                    subtitle: item.subtitle,
                                    amount: item.amount,
                                    networkAsset: segment == .card ? item.networkAsset : nil,
                                    badgeText: segment == .card ? (isBalanceVisible ? item.detailBadgeText : item.detailBadgeText.map { _ in "••••" }) : nil,
                                    showsFavoriteState: segment == .card && item.isStored == false,
                                    isFavorite: item.isFavorite,
                                    isLocked: item.isLocked
                                )
                            )
                        }
                    }
                )
                .padding(.horizontal, -RBHomeFlowLayout.pageHorizontalInset)
            }
        }
    }

    @ViewBuilder
    private func carouselCardContent(item: RBHomeFlowCarouselItem, segment: RBHomeFlowSegment) -> some View {
        switch segment {
        case .card:
            if item.isStored {
                RBProductCardRechargeContent(
                    model: .init(
                        cardName: item.title,
                        maskedNumber: .init(item.subtitle)
                    )
                )
            } else {
                RBProductCardPlasticContent(
                    model: .init(
                        amount: amountText(item.amount),
                        title: item.title,
                        maskedNumber: .init(item.subtitle),
                        brandImageName: item.networkAsset,
                        trailingIcons: .init(
                            showsEye: true,
                            isEyeOpen: isBalanceVisible,
                            showsFavorite: true,
                            isFavorite: item.isFavorite,
                            legacyEyeAssetName: isBalanceVisible ? "show" : "hide",
                            legacyFavoriteAssetName: item.isFavorite ? "favorite" : "unfavorite"
                        ),
                        bottomLeadingLabel: isBalanceVisible ? item.bottomLeadingLabel : item.bottomLeadingLabel.map { _ in "••••" }
                    ),
                    onTapEye: { isBalanceVisible.toggle() },
                    onTapFavorite: { onFavoriteTap?(item.id) }
                )
            }
        case .credit:
            RBProductCardDefaultContent(
                model: .init(
                    amount: amountText(item.amount),
                    title: item.title,
                    subtitle: item.subtitle,
                    trailingIcons: .init(showsEye: true, isEyeOpen: isBalanceVisible, showsFavorite: false)
                ),
                onTapEye: { isBalanceVisible.toggle() }
            )
        case .account:
            RBProductCardDefaultContent(
                model: .init(
                    amount: amountText(item.amount),
                    title: item.title,
                    subtitle: item.subtitle,
                    trailingIcons: .init(showsEye: true, isEyeOpen: isBalanceVisible, showsFavorite: false)
                ),
                onTapEye: { isBalanceVisible.toggle() }
            )
        case .deposit:
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

    func bonusSectionView(
        state: RBHomeFlowSectionState<RBHomeFlowCardBonusSection>
    ) -> some View {
        rbHomeFlowSectionStateView(state, minHeight: 86, skeleton: { RBHomeFlowBonusSummarySkeleton() }) { section in
            switch section {
            case .pair(let model):
                RBHomeFlowRefundPairSectionView(model: maskedBonusPair(model))
            case .edvOnly(let model):
                RBHomeFlowEDVRefundSectionView(model: maskedEDVModel(model))
            }
        }
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
        guard isBalanceVisible else {
            return .init(primary: "••••")
        }
        let parts = rawValue.split(separator: " ")
        guard parts.count > 1 else {
            return .init(primary: rawValue)
        }
        let rawSecondary = String(parts.last ?? "")
        let secondary = rawSecondary == "AZN" ? "₼" : rawSecondary
        let primary = parts.dropLast().joined(separator: " ")
        return .init(primary: primary, secondary: secondary)
    }

    private func maskedStatContent(_ content: RBStatCardContent) -> RBStatCardContent {
        guard !isBalanceVisible, case .data = content else { return content }
        return .data(amount: "••••", detail: "••••")
    }

    private func maskedEDVModel(_ model: RBHomeFlowEDVRefundModel) -> RBHomeFlowEDVRefundModel {
        .init(icon: model.icon, title: model.title, titleColor: model.titleColor,
              content: maskedStatContent(model.content), onTap: model.onTap)
    }

    private func maskedBonusPair(_ model: RBHomeFlowRefundPairModel) -> RBHomeFlowRefundPairModel {
        .init(leading: maskedEDVModel(model.leading), trailing: maskedEDVModel(model.trailing))
    }
}
