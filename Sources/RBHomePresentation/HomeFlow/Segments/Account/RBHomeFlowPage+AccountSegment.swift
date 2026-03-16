//
//  RBHomeFlowPage+AccountSegment.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 15.03.2026.
//

import SwiftUI
import RBDesignSystem

extension RBHomeFlowPage {
    @ViewBuilder
    func accountHomeBody(_ model: RBHomeFlowAccountHomeModel) -> some View {
        quickActionsSection(state: model.actionsState)
    }

    func accountHomePanel(_ model: RBHomeFlowAccountHomeModel) -> RBHomeFlowActivePanel {
        .transactions(model.panelState)
    }
}
