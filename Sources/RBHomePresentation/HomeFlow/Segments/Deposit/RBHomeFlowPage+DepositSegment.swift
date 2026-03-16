//
//  RBHomeFlowPage+DepositSegment.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 15.03.2026.
//

import SwiftUI
import RBDesignSystem

extension RBHomeFlowPage {
    @ViewBuilder
    func depositHomeBody(_ model: RBHomeFlowDepositHomeModel) -> some View {
        quickActionsSection(state: model.actionsState)
    }

    func depositHomePanel(_ model: RBHomeFlowDepositHomeModel) -> RBHomeFlowActivePanel {
        .transactions(model.panelState)
    }
}
