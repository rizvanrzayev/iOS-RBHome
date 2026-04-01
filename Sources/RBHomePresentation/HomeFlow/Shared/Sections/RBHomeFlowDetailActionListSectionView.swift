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

            VStack(spacing: 8) {
                ForEach(model.items) { item in
                    RBHomeFlowLegacyDetailActionRow(item: item)
                }
            }
        }
    }
}

private struct RBHomeFlowLegacyDetailActionRow: View {
    let item: RBHomeFlowDetailActionItem

    var body: some View {
        Button(action: item.onTap) {
            HStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.rb.backgroundSecondary)
                    .frame(width: 44, height: 44)
                    .overlay {
                        if let legacyIconAssetName = item.legacyIconAssetName {
                            Image(legacyIconAssetName)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color.rb.textPrimary)
                        } else {
                            item.icon.view(size: .small, color: .rb.textPrimary)
                        }
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.rb.body14(weight: .medium))
                        .foregroundStyle(Color.rb.textPrimary)
                        .multilineTextAlignment(.leading)

                    Text(item.description)
                        .font(.rb.caption())
                        .foregroundStyle(Color.rb.textSecondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.rb.textSecondary)
            }
            .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
            .padding(.horizontal, 16)
            .background(Color.rb.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
