//
//  RBHomeFlowCarouselErrorCell.swift
//  RBHomePresentation
//
//  Card-shaped error placeholder for the carousel section.
//  Renders with the same height as a loaded card so the floating panel
//  peek height stays stable in error state.
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowCarouselErrorCell: View {
    let title: String
    let message: String?
    let onRetry: (() -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            RBEmptyState(title: title, message: message, layout: .inline)
            if let onRetry {
                RBButton("Yenidən cəhd et") { onRetry() }
                    .padding(.horizontal, 24)
            }
        }
        .frame(maxWidth: .infinity, minHeight: RBHomeFlowLayout.detailPanelItemHeight)
        .padding(.vertical, 16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 4)
    }
}
