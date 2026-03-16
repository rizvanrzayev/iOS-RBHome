//
//  RBDetailHeaderView.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 13.03.2026.
//

import SwiftUI
import RBDesignSystem

struct RBDetailHeaderView: View {
    let title: String
    let onBackTap: () -> Void

    var body: some View {
        ZStack {
            Text(title)
                .font(.rb.subtitle())
                .foregroundStyle(Color.rb.textPrimary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .center)

            HStack {
                Button(action: onBackTap) {
                    RBIcon.custom(.navigationBack)
                        .view(size: .medium, color: .rb.navigationIcon)
                }
                .buttonStyle(.plain)
                .frame(width: 44, alignment: .leading)

                Spacer(minLength: 0)

                Color.clear
                    .frame(width: 44)
            }
        }
        .frame(height: 44)
    }
}
