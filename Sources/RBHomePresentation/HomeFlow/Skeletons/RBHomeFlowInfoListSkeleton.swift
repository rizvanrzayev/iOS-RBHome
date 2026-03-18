//
//  RBHomeFlowInfoListSkeleton.swift
//  RBHomePresentation
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowInfoListSkeleton: View {
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0 ..< 3, id: \.self) { index in
                HStack {
                    RBShimmerBox(cornerRadius: 4)
                        .frame(width: 100, height: 12)
                    Spacer()
                    RBShimmerBox(cornerRadius: 4)
                        .frame(width: 70, height: 12)
                }
                .padding(.vertical, 14)
                if index < 2 {
                    Divider()
                }
            }
        }
    }
}
