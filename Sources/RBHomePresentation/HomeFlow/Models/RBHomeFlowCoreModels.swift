//
//  RBHomeFlowCoreModels.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 12.03.2026.
//

import Foundation
import RBDesignSystem

public enum RBHomeFlowMode: CaseIterable, Hashable, Sendable {
    case home
    case detail
}

public enum RBHomeFlowSegment: Int, CaseIterable, Hashable, Sendable {
    case card
    case account
    case credit
    case deposit

    public var title: String {
        switch self {
        case .card:   return "Card"
        case .account:  return "Account"
        case .credit: return "Credit"
        case .deposit: return "Deposit"
        }
    }

    var carouselShellPreset: RBProductCardShellPreset {
        switch self {
        case .card, .credit: return .plastic
        case .account, .deposit: return .accountDefault
        }
    }
}

public enum RBHomeFlowSectionState<Value> {
    case loading
    case loaded(Value)
    case empty(title: String, message: String?)
    case error(title: String, message: String?)
    /// Section is intentionally absent — renders nothing.
    case hidden
}

extension RBHomeFlowSectionState: Equatable where Value: Equatable {}
