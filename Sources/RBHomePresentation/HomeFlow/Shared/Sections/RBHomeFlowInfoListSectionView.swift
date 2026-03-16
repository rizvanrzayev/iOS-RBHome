//
//  RBHomeFlowInfoListSectionView.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 13.03.2026.
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowInfoListSectionView: View {
    let model: RBHomeFlowInfoListModel

    var body: some View {
        VStack(alignment: .leading, spacing: RBHomeFlowLayout.sectionContentSpacing) {
            if let title = model.title, title.isEmpty == false {
                Text(title)
                    .font(.rb.body14(weight: .semibold))
                    .foregroundStyle(Color.rb.textPrimary)
            }

            VStack(spacing: 10) {
                ForEach(model.items) { item in
                    RBKeyValueRow(model: .init(
                        id: item.id,
                        title: item.title,
                        subtitle: item.subtitle,
                        value: item.value
                    ))
                }
            }
        }
    }
}
