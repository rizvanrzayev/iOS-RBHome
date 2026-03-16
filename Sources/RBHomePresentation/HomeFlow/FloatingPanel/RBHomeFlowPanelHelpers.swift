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
