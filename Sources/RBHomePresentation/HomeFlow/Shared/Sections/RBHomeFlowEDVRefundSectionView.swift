//
//  RBHomeFlowEDVRefundSectionView.swift
//  RBHomePresentation
//
//  Created by Rizvan Rzayev on 19.03.2026.
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowEDVRefundSectionView: View {
    let model: RBHomeFlowEDVRefundModel

    var body: some View {
        RBStatCard(
            icon: model.icon,
            title: model.title,
            titleColor: model.titleColor,
            content: model.content,
            style: .fullWidth,
            onTap: model.onTap
        )
    }
}
