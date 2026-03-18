//
//  RBHomeFlowTransactionsSkeleton.swift
//  RBHomePresentation
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowTransactionsSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RBShimmerBox(cornerRadius: 4)
                .frame(width: 80, height: 12)
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .padding(.bottom, 12)

            ForEach(0 ..< 5, id: \.self) { index in
                transactionRow
                if index < 4 {
                    Divider()
                        .padding(.leading, 84)
                }
            }
        }
    }

    private var transactionRow: some View {
        HStack(spacing: 0) {
            Circle()
                .fill(Color(hex: "#F0F1F5"))
                .frame(width: 40, height: 40)
                .rbShimmer()
                .padding(.leading, 24)
                .padding(.trailing, 20)

            VStack(alignment: .leading, spacing: 6) {
                RBShimmerBox(cornerRadius: 4)
                    .frame(width: 120, height: 12)
                RBShimmerBox(cornerRadius: 4)
                    .frame(width: 80, height: 10)
            }

            Spacer()

            RBShimmerBox(cornerRadius: 4)
                .frame(width: 60, height: 12)
                .padding(.trailing, 24)
        }
        .padding(.vertical, 14)
    }
}
