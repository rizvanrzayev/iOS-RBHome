//
//  RBHomeFlowPage+AccountDetailSegment.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 15.03.2026.
//

import SwiftUI
import RBDesignSystem

extension RBHomeFlowPage {
    @ViewBuilder
    func accountDetailBody(_ model: RBHomeFlowAccountDetailModel) -> some View {
        if visualMode == .detail {
            rbHomeFlowSectionStateView(model.infoState, minHeight: 136, skeleton: { RBHomeFlowInfoListSkeleton() }) { m in
                RBHomeFlowInfoListSectionView(model: .init(items: m.items))
            }
        }
    }

    func accountDetailPanel(_ model: RBHomeFlowAccountDetailModel) -> RBHomeFlowActivePanel {
        .actions(model.actionsState)
    }
}
