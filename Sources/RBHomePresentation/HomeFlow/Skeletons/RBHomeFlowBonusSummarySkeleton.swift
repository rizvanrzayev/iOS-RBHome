//
//  RBHomeFlowBonusSummarySkeleton.swift
//  RBHomePresentation
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowBonusSummarySkeleton: View {
    var body: some View {
        HStack(spacing: 0) {
            bonusItem
            Divider()
                .frame(width: 1, height: 36)
            bonusItem
        }
        .frame(maxWidth: .infinity)
    }

    private var bonusItem: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(Color(hex: "#F0F1F5"))
                .frame(width: 36, height: 36)
                .rbShimmer()
            VStack(alignment: .leading, spacing: 6) {
                RBShimmerBox(cornerRadius: 4)
                    .frame(width: 60, height: 10)
                RBShimmerBox(cornerRadius: 4)
                    .frame(width: 80, height: 10)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
}
