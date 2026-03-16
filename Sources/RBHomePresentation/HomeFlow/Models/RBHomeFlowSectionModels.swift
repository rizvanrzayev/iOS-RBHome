//
//  RBHomeFlowSectionModels.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 12.03.2026.
//

import Foundation
import RBDesignSystem

// MARK: - Profile Header

public struct RBHomeFlowProfileHeaderAction {
    public let systemImage: String
    public let onTap: () -> Void

    public init(systemImage: String, onTap: @escaping () -> Void) {
        self.systemImage = systemImage
        self.onTap = onTap
    }
}

public struct RBHomeFlowProfileHeaderModel {
    public let avatarText: String
    public let fullName: String
    public let avatarAction: (() -> Void)?
    public let qrAction: RBHomeFlowProfileHeaderAction?
    public let notificationAction: RBHomeFlowProfileHeaderAction?

    public init(
        avatarText: String,
        fullName: String,
        avatarAction: (() -> Void)? = nil,
        qrAction: RBHomeFlowProfileHeaderAction? = nil,
        notificationAction: RBHomeFlowProfileHeaderAction? = nil
    ) {
        self.avatarText = avatarText
        self.fullName = fullName
        self.avatarAction = avatarAction
        self.qrAction = qrAction
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

    public init(id: String, title: String, subtitle: String, amount: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.amount = amount
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
    public let systemImage: String
    public let onTap: () -> Void

    public init(id: String, title: String, systemImage: String, onTap: @escaping () -> Void) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
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
    public let systemImage: String
    public let onTap: () -> Void

    public init(id: String, title: String, description: String, systemImage: String, onTap: @escaping () -> Void) {
        self.id = id
        self.title = title
        self.description = description
        self.systemImage = systemImage
        self.onTap = onTap
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

    public init(id: String, date: String?, title: String, subtitle: String? = nil, amount: String, isCredit: Bool) {
        self.id = id
        self.date = date
        self.title = title
        self.subtitle = subtitle
        self.amount = amount
        self.isCredit = isCredit
    }
}

public enum RBHomeFlowPanelFilter {
    case today
    case thisWeek
    case thisMonth
    case custom(from: Date, to: Date)
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

// MARK: - Active Panel

enum RBHomeFlowActivePanel {
    case transactions(RBHomeFlowSectionState<RBHomeFlowPanelModel>)
    case actions(RBHomeFlowSectionState<RBHomeFlowDetailActionsModel>)
}
