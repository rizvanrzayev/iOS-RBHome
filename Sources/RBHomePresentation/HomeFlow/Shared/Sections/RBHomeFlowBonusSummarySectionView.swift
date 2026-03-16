//
//  RBHomeFlowBonusSummarySectionView.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 13.03.2026.
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowBonusSummarySectionView: View {
    let model: RBHomeFlowBonusSummaryModel

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(model.items.enumerated()), id: \.element.id) { index, item in
                if index > 0 {
                    Rectangle()
                        .fill(Color.rb.separator)
                        .frame(width: 1)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 24)
                }
                bonusItem(item)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(20)
    }

    private func bonusItem(_ item: RBHomeFlowBonusSummaryItem) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(RBHomeFlowLayout.pageBackgroundColor)
                    .frame(width: 36, height: 36)

                Image(systemName: item.systemImage)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.rb.textPrimary)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(item.value)
                    .font(.rb.body(weight: .bold))
                    .foregroundStyle(Color.rb.textPrimary)

                Text(item.title)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(Color.rb.textSecondary)
            }
        }
    }
}
