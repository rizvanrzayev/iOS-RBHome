//
//  RBHomeFlowRefundPairSectionView.swift
//  RBHomePresentation
//
//  Created by Rizvan Rzayev on 19.03.2026.
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowRefundPairSectionView: View {
    let model: RBHomeFlowRefundPairModel

    var body: some View {
        HStack(spacing: 12) {
            RBStatCard(
                icon: model.leading.icon,
                title: model.leading.title,
                titleColor: model.leading.titleColor,
                content: model.leading.content,
                style: .compact,
                onTap: model.leading.onTap
            )
            RBStatCard(
                icon: model.trailing.icon,
                title: model.trailing.title,
                titleColor: model.trailing.titleColor,
                content: model.trailing.content,
                style: .compact,
                onTap: model.trailing.onTap
            )
        }
    }
}
