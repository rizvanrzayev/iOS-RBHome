//
//  RBHomeFlowSwipeableTransactionRow.swift
//  RBHomePresentation
//
//  Created by Rizvan Rzayev on 31.03.2026.
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowSwipeableTransactionRow<Content: View>: View {
    let actions: [RBHomeFlowPanelSwipeAction]
    @ViewBuilder let content: () -> Content

    var body: some View {
        if actions.isEmpty {
            content()
        } else {
            content()
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    ForEach(actions) { action in
                        Button(action: action.onTap) {
                            Label(action.title, systemImage: action.systemImage)
                        }
                        .tint(action.tint)
                    }
                }
        }
    }
}

private extension RBHomeFlowPanelSwipeAction {
    var title: String {
        switch kind {
        case .splitBill:
            return "Split bill"
        case .chargeback:
            return "Chargeback"
        }
    }

    var systemImage: String {
        switch kind {
        case .splitBill:
            return "person.2.fill"
        case .chargeback:
            return "arrow.uturn.backward.circle.fill"
        }
    }

    var tint: Color {
        switch kind {
        case .splitBill:
            return .rb.selectionGreen
        case .chargeback:
            return .rb.primary
        }
    }
}
