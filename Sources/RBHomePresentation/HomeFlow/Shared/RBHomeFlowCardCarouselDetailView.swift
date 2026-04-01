//
//  RBHomeFlowCardCarouselDetailView.swift
//  RBHomePresentation
//
//  Created by Rizvan Rzayev on 01.04.2026.
//

import SwiftUI
import UIKit
import RBDesignSystem

struct RBHomeFlowCardCarouselDetailView: View {
    @EnvironmentObject private var snackBarManager: RBSnackBarManager

    let content: RBHomeFlowCardDetailContent
    let amountText: String

    @State private var revealedCVV: String?
    @State private var isCVVVisible = false
    @State private var isCVVLoading = false

    private var parsedAmount: RBProductCardAmountText {
        let parts = amountText.split(separator: " ")
        guard parts.count > 1 else { return .init(primary: amountText) }
        return .init(
            primary: parts.dropLast().joined(separator: " "),
            secondary: String(parts.last ?? "")
        )
    }

    var body: some View {
        detailsColumn
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(RBHomeFlowLayout.pageBackgroundColor)
        .overlay(alignment: .center) {
            if content.isLocked {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.rb.backgroundSecondary.opacity(0.78))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var detailsColumn: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(content.cardName)
                    .font(.rb.caption())
                    .foregroundStyle(Color.rb.textSecondary)
                    .lineLimit(1)

                if content.isRecharge == false {
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

                if let bankLogoURL = content.bankLogoURL,
                   let url = URL(string: bankLogoURL),
                   content.isRecharge {
                    RBImage(
                        source: .remote(url: url),
                        style: .cardIcon
                    )
                    .frame(width: 64, height: 28)
                }
            }

            RBSensitiveValueField(
                style: .valueOnly,
                displayedValue: content.panText,
                onCopy: content.panCopyValue.map { copyValue in
                    { copy(copyValue, title: "Kart nömrəsi kopyalandı") }
                }
            )

            HStack(alignment: .center, spacing: 20) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Date")
                        .font(.rb.caption())
                        .foregroundStyle(Color.rb.textSecondary)

                    Text(content.expiryText)
                        .font(.rb.body14(weight: .semibold))
                        .foregroundStyle(Color.rb.textPrimary)
                        .lineLimit(1)
                }

                if content.isRecharge == false {
                    RBSensitiveValueField(
                        style: .capsule,
                        displayedValue: cvvDisplayValue,
                        isLoading: isCVVLoading,
                        canReveal: content.onFetchCVV != nil,
                        isRevealed: isCVVVisible,
                        onTap: handleCVVToggle,
                        onToggleReveal: handleCVVToggle
                    )
                }
            }

            Spacer(minLength: 0)
        }
    }

    private var cvvDisplayValue: String {
        if let revealedCVV, isCVVVisible {
            return "\(revealedCVV)🤗"
        }
        return "🤔CVV"
    }

    private func handleCVVToggle() {
        if isCVVVisible {
            isCVVVisible = false
            return
        }

        if let revealedCVV {
            isCVVVisible = true
            return
        }

        guard let onFetchCVV = content.onFetchCVV, isCVVLoading == false else { return }
        isCVVLoading = true
        onFetchCVV { result in
            DispatchQueue.main.async {
                isCVVLoading = false
                switch result {
                case .success(let cvv):
                    revealedCVV = cvv
                    isCVVVisible = true
                case .failure(let error):
                    snackBarManager.show(
                        RBSnackBarItem(
                            title: error.localizedDescription.isEmpty ? "CVV əldə olunmadı" : error.localizedDescription,
                            style: .error,
                            position: .bottom
                        )
                    )
                }
            }
        }
    }

    private func copy(_ value: String, title: String) {
        UIPasteboard.general.string = value
        snackBarManager.show(
            RBSnackBarItem(
                title: title,
                style: .success,
                position: .bottom
            )
        )
    }
}
