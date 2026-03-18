//
//  RBHomeFlowQuickActionsSkeleton.swift
//  RBHomePresentation
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowQuickActionsSkeleton: View {
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0 ..< 3, id: \.self) { _ in
                VStack(spacing: 6) {
                    Circle()
                        .fill(Color(hex: "#F0F1F5"))
                        .frame(width: 52, height: 52)
                        .rbShimmer()
                        .clipShape(Circle())
                    RBShimmerBox(cornerRadius: 4)
                        .frame(width: 48, height: 14)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
