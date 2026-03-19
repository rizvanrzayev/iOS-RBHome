//
//  RBHomeFlowSectionModels.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 12.03.2026.
//

import Foundation
import RBDesignSystem
import SwiftUI

// MARK: - Profile Header

public struct RBHomeFlowProfileHeaderAction {
    public let icon: RBIcon
    public let onTap: () -> Void

    public init(icon: RBIcon, onTap: @escaping () -> Void) {
        self.icon = icon
        self.onTap = onTap
    }

    public init(systemImage: String, onTap: @escaping () -> Void) {
        self.init(icon: .system(systemImage), onTap: onTap)
    }
}

public struct RBHomeFlowProfileHeaderModel {
    public let avatarText: String
    public let fullName: String
    public let avatarAction: (() -> Void)?
    public let qrAction: RBHomeFlowProfileHeaderAction?
    public let chatAction: RBHomeFlowProfileHeaderAction?
    public let notificationAction: RBHomeFlowProfileHeaderAction?

    public init(
        avatarText: String,
        fullName: String,
        avatarAction: (() -> Void)? = nil,
        qrAction: RBHomeFlowProfileHeaderAction? = nil,
        chatAction: RBHomeFlowProfileHeaderAction? = nil,
        notificationAction: RBHomeFlowProfileHeaderAction? = nil
    ) {
        self.avatarText = avatarText
        self.fullName = fullName
        self.avatarAction = avatarAction
        self.qrAction = qrAction
        self.chatAction = chatAction
        self.notificationAction = notificationAction
    }
}

// MARK: - Carousel

protocol RBHomeFlowCarouselCollection {
    var carouselIDs: [String] { get }
}

public struct RBHomeFlowCarouselItem: Identifiable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let amount: String
    /// Asset name for card network logo (e.g. "ds_card_visa"). Nil for non-card segments.
    public let networkAsset: String?
    /// Optional label shown at the bottom-leading corner of the card (e.g. "Bonus: 120 xal").
    public let bottomLeadingLabel: String?
    /// True for stored/external-bank cards — renders recharge content instead of plastic.
    public let isStored: Bool

    public init(id: String, title: String, subtitle: String, amount: String, networkAsset: String? = nil, bottomLeadingLabel: String? = nil, isStored: Bool = false) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.amount = amount
        self.networkAsset = networkAsset
        self.bottomLeadingLabel = bottomLeadingLabel
        self.isStored = isStored
    }
}

public struct RBHomeFlowCarouselModel {
    public let title: String?
    public let items: [RBHomeFlowCarouselItem]

    public init(title: String? = nil, items: [RBHomeFlowCarouselItem]) {
        self.title = title
        self.items = items
    }
}

extension RBHomeFlowCarouselModel: RBHomeFlowCarouselCollection {
    var carouselIDs: [String] { items.map(\.id) }
}

// MARK: - Quick Actions

public struct RBHomeFlowQuickActionItem: Identifiable {
    public let id: String
    public let title: String
    public let icon: RBIcon
    public let onTap: () -> Void

    public init(id: String, title: String, icon: RBIcon, onTap: @escaping () -> Void) {
        self.id = id
        self.title = title
        self.icon = icon
        self.onTap = onTap
    }
}

public struct RBHomeFlowQuickActionsModel {
    public let title: String?
    public let items: [RBHomeFlowQuickActionItem]

    public init(title: String? = nil, items: [RBHomeFlowQuickActionItem]) {
        self.title = title
        self.items = items
    }
}

// MARK: - Bonus Summary

public struct RBHomeFlowBonusSummaryItem: Identifiable {
    public let id: String
    public let systemImage: String
    public let title: String
    public let value: String

    public init(id: String, systemImage: String, title: String, value: String) {
        self.id = id
        self.systemImage = systemImage
        self.title = title
        self.value = value
    }
}

public struct RBHomeFlowBonusSummaryModel {
    public let items: [RBHomeFlowBonusSummaryItem]

    public init(items: [RBHomeFlowBonusSummaryItem]) {
        self.items = items
    }
}

// MARK: - Detail Actions

public struct RBHomeFlowDetailActionItem: Identifiable {
    public let id: String
    public let title: String
    public let description: String
    public let icon: RBIcon
    public let onTap: () -> Void

    public init(id: String, title: String, description: String, icon: RBIcon, onTap: @escaping () -> Void) {
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
        self.onTap = onTap
    }

    public init(id: String, title: String, description: String, systemImage: String, onTap: @escaping () -> Void) {
        self.init(id: id, title: title, description: description, icon: .system(systemImage), onTap: onTap)
    }
}

public struct RBHomeFlowDetailActionsModel {
    public let title: String?
    public let items: [RBHomeFlowDetailActionItem]

    public init(title: String? = nil, items: [RBHomeFlowDetailActionItem]) {
        self.title = title
        self.items = items
    }
}

// MARK: - Info List

public struct RBHomeFlowInfoListItem: Identifiable {
    public let id: String
    public let title: String
    public let subtitle: String?
    public let value: String?

    public init(id: String, title: String, subtitle: String? = nil, value: String? = nil) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.value = value
    }
}

public struct RBHomeFlowInfoListModel {
    public let title: String?
    public let items: [RBHomeFlowInfoListItem]

    public init(title: String? = nil, items: [RBHomeFlowInfoListItem]) {
        self.title = title
        self.items = items
    }
}

// MARK: - Panel

public struct RBHomeFlowPanelItem: Identifiable {
    public let id: String
    public let date: String?
    public let title: String
    public let subtitle: String?
    public let amount: String
    public let isCredit: Bool
    public let iconURL: String?
    public let iconColorHex: String?

    public init(id: String, date: String?, title: String, subtitle: String? = nil, amount: String, isCredit: Bool, iconURL: String? = nil, iconColorHex: String? = nil) {
        self.id = id
        self.date = date
        self.title = title
        self.subtitle = subtitle
        self.amount = amount
        self.isCredit = isCredit
        self.iconURL = iconURL
        self.iconColorHex = iconColorHex
    }
}

public enum RBHomeFlowPanelFilter: Equatable {
    case today
    case thisWeek
    case thisMonth
    case custom(from: Date, to: Date)
}

extension RBHomeFlowPanelFilter {
    var dateRange: (from: Date, to: Date) {
        let cal = Calendar.current
        let now = Date()
        switch self {
        case .today:
            let start = cal.startOfDay(for: now)
            let end = cal.date(byAdding: DateComponents(day: 1, second: -1), to: start)!
            return (start, end)
        case .thisWeek:
            let start = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            let end = cal.date(byAdding: DateComponents(day: 7, second: -1), to: start)!
            return (start, end)
        case .thisMonth:
            let start = cal.date(from: cal.dateComponents([.year, .month], from: now))!
            let end = cal.date(byAdding: DateComponents(month: 1, second: -1), to: start)!
            return (start, end)
        case .custom(let from, let to):
            let start = cal.startOfDay(for: from)
            let end = cal.date(byAdding: DateComponents(day: 1, second: -1), to: cal.startOfDay(for: to))!
            return (start, end)
        }
    }
}

public struct RBHomeFlowPanelModel {
    public let title: String
    public let items: [RBHomeFlowPanelItem]
    public let onSearchChange: ((String) -> Void)?
    public let onFilterChange: ((RBHomeFlowPanelFilter?) -> Void)?

    public init(
        title: String,
        items: [RBHomeFlowPanelItem],
        onSearchChange: ((String) -> Void)? = nil,
        onFilterChange: ((RBHomeFlowPanelFilter?) -> Void)? = nil
    ) {
        self.title = title
        self.items = items
        self.onSearchChange = onSearchChange
        self.onFilterChange = onFilterChange
    }
}

// MARK: - EDV Refund

public struct RBHomeFlowEDVRefundModel {
    public let icon: RBIcon
    public let title: String
    public let titleColor: Color
    public let content: RBStatCardContent
    public let onTap: () -> Void

    public init(
        icon: RBIcon,
        title: String,
        titleColor: Color = Color.rb.edvBlue,
        content: RBStatCardContent,
        onTap: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.titleColor = titleColor
        self.content = content
        self.onTap = onTap
    }
}

// MARK: - Card Bonus Section

/// Represents the two possible layouts for the bonus/EDV section in the Card segment.
public enum RBHomeFlowCardBonusSection {
    /// Bonus is visible: two compact stat cards side by side (Bonuslarım + ƏDV geri al).
    case pair(RBHomeFlowRefundPairModel)
    /// Bonus not visible: single full-width EDV card.
    case edvOnly(RBHomeFlowEDVRefundModel)
}

// MARK: - EDV Refund Pair

public struct RBHomeFlowRefundPairModel {
    public let leading: RBHomeFlowEDVRefundModel
    public let trailing: RBHomeFlowEDVRefundModel

    public init(leading: RBHomeFlowEDVRefundModel, trailing: RBHomeFlowEDVRefundModel) {
        self.leading = leading
        self.trailing = trailing
    }
}

// MARK: - Active Panel

enum RBHomeFlowActivePanel {
    case transactions(RBHomeFlowSectionState<RBHomeFlowPanelModel>)
    case actions(RBHomeFlowSectionState<RBHomeFlowDetailActionsModel>)
}
