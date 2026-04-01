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
    let networkAsset: String?
    let badgeText: String?
    let showsFavoriteState: Bool
    let isFavorite: Bool
    let isLocked: Bool

    private var parsedAmount: RBProductCardAmountText {
        let parts = amount.split(separator: " ")
        guard parts.count > 1 else { return .init(primary: amount) }
        let secondary = String(parts.last ?? "")
        let primary = parts.dropLast().joined(separator: " ")
        return .init(primary: primary, secondary: secondary)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text(segmentLabel)
                    .font(.rb.body14(weight: .semibold))
                    .foregroundStyle(Color.rb.textSecondary)

                Spacer(minLength: 0)

                if let networkAsset {
                    Image(networkAsset)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 20)
                }
            }

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

            if badgeText != nil || showsFavoriteState || isLocked {
                HStack(spacing: 8) {
                    if let badgeText, badgeText.isEmpty == false {
                        statusPill(text: badgeText, tint: Color.rb.backgroundSecondary, foreground: Color.rb.textPrimary)
                    }

                    if showsFavoriteState {
                        statusPill(
                            text: isFavorite ? "Seçilmiş kart" : "Adi kart",
                            tint: isFavorite ? Color.rb.green.opacity(0.16) : Color.rb.backgroundSecondary,
                            foreground: isFavorite ? Color.rb.green : Color.rb.textSecondary
                        )
                    }

                    if isLocked {
                        statusPill(text: "Bloklu", tint: Color.rb.error.opacity(0.14), foreground: Color.rb.error)
                    }
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

    @ViewBuilder
    private func statusPill(text: String, tint: Color, foreground: Color) -> some View {
        Text(text)
            .font(.rb.caption())
            .foregroundStyle(foreground)
            .lineLimit(1)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(tint)
            .clipShape(Capsule())
    }
}
