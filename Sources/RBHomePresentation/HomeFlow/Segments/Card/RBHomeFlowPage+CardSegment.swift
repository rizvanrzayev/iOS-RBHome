//
//  RBHomeFlowPage+CardSegment.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 15.03.2026.
//

import SwiftUI
import RBDesignSystem

extension RBHomeFlowPage {
    @ViewBuilder
    func cardHomeBody(_ model: RBHomeFlowCardHomeModel) -> some View {
        quickActionsSection(state: model.quickActionsState)
        if visualMode == .home {
            bonusSectionView(state: model.bonusSectionState)
        }
    }

    func cardHomePanel(_ model: RBHomeFlowCardHomeModel) -> RBHomeFlowActivePanel {
        .transactions(model.panelState)
    }
}
