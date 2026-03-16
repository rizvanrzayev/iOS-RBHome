//
//  RBHomeFlowPage+CardDetailSegment.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 15.03.2026.
//

import SwiftUI
import RBDesignSystem

extension RBHomeFlowPage {
    @ViewBuilder
    func cardDetailBody(_ model: RBHomeFlowCardDetailModel) -> some View {
        quickActionsSection(state: model.quickActionsState)
    }

    func cardDetailPanel(_ model: RBHomeFlowCardDetailModel) -> RBHomeFlowActivePanel {
        .actions(model.actionsState)
    }
}
