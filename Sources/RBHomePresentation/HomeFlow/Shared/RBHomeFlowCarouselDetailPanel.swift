//
//  RBHomeFlowCarouselDetailPanel.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 13.03.2026.
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowCarouselDetailPanel: View {
    let segmentLabel: String
    let title: String
    let subtitle: String
    let amount: String

    private var parsedAmount: RBProductCardAmountText {
        let parts = amount.split(separator: " ")
        guard parts.count > 1 else { return .init(primary: amount) }
        let secondary = String(parts.last ?? "")
        let primary = parts.dropLast().joined(separator: " ")
        return .init(primary: primary, secondary: secondary)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(segmentLabel)
                .font(.rb.body14(weight: .semibold))
                .foregroundStyle(Color.rb.textSecondary)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(parsedAmount.primary)
                    .font(.rb.h3())
                    .foregroundStyle(Color.rb.textPrimary)
                    .lineLimit(1)

                if let secondary = parsedAmount.secondary {
                    Text(secondary)
                        .font(.rb.body14(weight: .semibold))
                        .foregroundStyle(Color.rb.textSecondary)
                        .lineLimit(1)
                }
            }

            Text(title)
                .font(.rb.body14(weight: .semibold))
                .foregroundStyle(Color.rb.textPrimary)
                .lineLimit(1)

            Text(subtitle)
                .font(.rb.body())
                .foregroundStyle(Color.rb.textSecondary)
                .lineLimit(1)

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(RBHomeFlowLayout.pageBackgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.rb.separator, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
