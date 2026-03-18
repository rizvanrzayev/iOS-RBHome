//
//  RBHomeFlowDetailActionsSkeleton.swift
//  RBHomePresentation
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowDetailActionsSkeleton: View {
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0 ..< 5, id: \.self) { _ in
                actionRow
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }

    private var actionRow: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#F0F1F5"))
                .frame(width: 44, height: 44)
                .rbShimmer()

            VStack(alignment: .leading, spacing: 6) {
                RBShimmerBox(cornerRadius: 4)
                    .frame(width: 120, height: 12)
                RBShimmerBox(cornerRadius: 4)
                    .frame(width: 180, height: 10)
            }

            Spacer()
        }
        .padding(.vertical, 10)
    }
}
