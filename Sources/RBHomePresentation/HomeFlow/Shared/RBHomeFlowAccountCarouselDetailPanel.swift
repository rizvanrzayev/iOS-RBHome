//
//  RBHomeFlowAccountCarouselDetailPanel.swift
//  RBHomePresentation
//
//  Created by Rizvan Rzayev on 01.04.2026.
//

import SwiftUI
import UIKit
import RBDesignSystem

struct RBHomeFlowAccountCarouselDetailPanel: View {
    let caption: String
    let amount: String
    let infoTitle: String
    let infoValue: String

    private var parsedAmount: RBProductCardAmountText {
        let parts = amount.split(separator: " ")
        guard parts.count > 1 else { return .init(primary: amount) }
        let secondary = String(parts.last ?? "")
        let primary = parts.dropLast().joined(separator: " ")
        return .init(primary: primary, secondary: secondary)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text(caption)
                    .font(.rb.caption())
                    .foregroundStyle(Color.rb.textSecondary)
                    .lineLimit(1)

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
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(infoTitle)
                    .font(.rb.caption())
                    .foregroundStyle(Color.rb.textSecondary)

                HStack(spacing: 6) {
                    Text(normalizedInfoValue)
                        .font(.rb.body14(weight: .semibold))
                        .foregroundStyle(Color.rb.textPrimary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)

                    if infoValue.isEmpty == false {
                        Button(action: copyValue) {
                            Image("copy_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

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

    private var normalizedInfoValue: String {
        infoValue.replacingOccurrences(of: "-", with: "")
    }

    private func copyValue() {
        UIPasteboard.general.string = normalizedInfoValue
    }
}
