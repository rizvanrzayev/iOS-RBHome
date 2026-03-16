//
//  RBHomeFlowSectionStateView.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 13.03.2026.
//

import SwiftUI
import RBDesignSystem

@ViewBuilder
func rbHomeFlowSectionStateView<Value, Content: View>(
    _ state: RBHomeFlowSectionState<Value>,
    minHeight: CGFloat,
    @ViewBuilder content: (Value) -> Content
) -> some View {
    switch state {
    case .loading:
        RBLoadingView(size: 56, isFullscreen: false)
            .frame(maxWidth: .infinity, minHeight: minHeight, alignment: .center)
    case .loaded(let value):
        content(value)
            .frame(maxWidth: .infinity, alignment: .leading)
    case .empty(let title, let message):
        RBEmptyState(title: title, message: message, layout: .inline)
            .frame(maxWidth: .infinity, minHeight: minHeight, alignment: .top)
    case .error(let title, let message):
        RBEmptyState(title: title, message: message, layout: .inline)
            .frame(maxWidth: .infinity, minHeight: minHeight, alignment: .top)
    case .hidden:
        EmptyView()
    }
}
