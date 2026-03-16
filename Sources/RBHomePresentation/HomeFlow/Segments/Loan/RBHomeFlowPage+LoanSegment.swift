//
//  RBHomeFlowPage+LoanSegment.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 15.03.2026.
//

import SwiftUI
import RBDesignSystem

extension RBHomeFlowPage {
    @ViewBuilder
    func loanHomeBody(_ model: RBHomeFlowLoanHomeModel) -> some View {
        quickActionsSection(state: model.actionsState)
    }

    func loanHomePanel(_ model: RBHomeFlowLoanHomeModel) -> RBHomeFlowActivePanel {
        .transactions(model.panelState)
    }
}
