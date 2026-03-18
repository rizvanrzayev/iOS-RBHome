//
//  RBHomeFlowPage+DepositDetailSegment.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 15.03.2026.
//

import SwiftUI
import RBDesignSystem

extension RBHomeFlowPage {
    @ViewBuilder
    func depositDetailBody(_ model: RBHomeFlowDepositDetailModel) -> some View {
        if visualMode == .detail {
            rbHomeFlowSectionStateView(model.conditionsState, minHeight: 136, skeleton: { RBHomeFlowInfoListSkeleton() }) { m in
                RBHomeFlowInfoListSectionView(model: .init(items: m.items))
            }
        }
    }

    func depositDetailPanel(_ model: RBHomeFlowDepositDetailModel) -> RBHomeFlowActivePanel {
        .actions(model.actionsState)
    }
}
