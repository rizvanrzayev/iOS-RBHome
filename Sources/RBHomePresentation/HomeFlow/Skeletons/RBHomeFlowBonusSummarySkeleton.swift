//
//  RBHomeFlowBonusSummarySkeleton.swift
//  RBHomePresentation
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowBonusSummarySkeleton: View {
    var body: some View {
        HStack(spacing: 12) {
            statCardSkeleton
            statCardSkeleton
        }
    }

    private var statCardSkeleton: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Icon + title row
            HStack(spacing: 8) {
                RBShimmerBox(cornerRadius: 4)
                    .frame(width: 16, height: 16)
                RBShimmerBox(cornerRadius: 4)
                    .frame(width: 72, height: 12)
            }
            // Amount
            RBShimmerBox(cornerRadius: 4)
                .frame(width: 88, height: 18)
            // Detail
            RBShimmerBox(cornerRadius: 4)
                .frame(width: 100, height: 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
