//
//  RBHomeFlowDetailActionListSectionView.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 13.03.2026.
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowDetailActionListSectionView: View {
    let model: RBHomeFlowDetailActionsModel

    var body: some View {
        VStack(alignment: .leading, spacing: RBHomeFlowLayout.sectionContentSpacing) {
            if let title = model.title, title.isEmpty == false {
                Text(title)
                    .font(.rb.body14(weight: .semibold))
                    .foregroundStyle(Color.rb.textPrimary)
            }

            VStack(spacing: RBHomeFlowLayout.iconTextSpacing) {
                ForEach(model.items) { item in
                    RBActionRow(model: .init(
                        id: item.id,
                        systemImage: item.systemImage,
                        title: item.title,
                        description: item.description,
                        onTap: item.onTap
                    ))
                }
            }
        }
    }
}
