//
//  RBHomeFlowHeaderSkeleton.swift
//  RBHomePresentation
//

import SwiftUI
import RBDesignSystem

/// Skeleton placeholder for the profile header during loading state.
/// Mirrors the layout of `RBHomeHeaderView`: avatar circle + name bar + spacer + two icon buttons.
struct RBHomeFlowHeaderSkeleton: View {
    private let shimmerColor = Color(hex: "#F0F1F5")

    var body: some View {
        HStack(spacing: RBHomeFlowLayout.sectionContentSpacing) {
            // Avatar circle
            Circle()
                .fill(shimmerColor)
                .frame(width: 40, height: 40)
                .rbShimmer()
                .clipShape(Circle())

            // Name bar
            RBShimmerBox(cornerRadius: 4)
                .frame(width: 120, height: 14)

            Spacer(minLength: 0)

            // Action button placeholders (scan + chat + notification)
            HStack(spacing: 16) {
                ForEach(0..<3, id: \.self) { _ in
                    Circle()
                        .fill(shimmerColor)
                        .frame(width: 24, height: 24)
                        .rbShimmer()
                        .clipShape(Circle())
                }
            }
        }
    }
}
