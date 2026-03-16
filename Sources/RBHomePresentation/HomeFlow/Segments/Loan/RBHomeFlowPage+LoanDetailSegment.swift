//
//  RBHomeFlowPage+LoanDetailSegment.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 15.03.2026.
//

import SwiftUI
import RBDesignSystem

extension RBHomeFlowPage {
    @ViewBuilder
    func loanDetailBody(_ model: RBHomeFlowLoanDetailModel) -> some View {
        if visualMode == .detail {
            rbHomeFlowSectionStateView(model.scheduleState, minHeight: 136) { m in
                RBHomeFlowInfoListSectionView(model: .init(items: m.items))
            }
        }
    }

    func loanDetailPanel(_ model: RBHomeFlowLoanDetailModel) -> RBHomeFlowActivePanel {
        .actions(model.actionsState)
    }
}
