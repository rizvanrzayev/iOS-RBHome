//
//  RBHomeFlowQuickActionsSectionView.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 13.03.2026.
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowQuickActionsSectionView: View {
    let model: RBHomeFlowQuickActionsModel

    var body: some View {
        VStack(alignment: .center, spacing: RBHomeFlowLayout.sectionContentSpacing) {
            if let title = model.title, title.isEmpty == false {
                Text(title)
                    .font(.rb.body14(weight: .semibold))
                    .foregroundStyle(Color.rb.textPrimary)
            }

            HStack(spacing: 0) {
                ForEach(model.items) { item in
                    RBQuickActionButton(
                        icon: .system(item.systemImage),
                        title: item.title,
                        style: .primary,
                        buttonSize: 52,
                        iconSize: .custom(20),
                        action: item.onTap
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
