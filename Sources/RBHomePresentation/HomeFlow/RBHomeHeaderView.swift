//
//  RBHomeHeaderView.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 13.03.2026.
//

import SwiftUI
import RBDesignSystem

struct RBHomeHeaderView: View {
    let model: RBHomeFlowProfileHeaderModel

    private var actions: [RBHomeFlowProfileHeaderAction] {
        [model.qrAction, model.notificationAction].compactMap { $0 }
    }

    var body: some View {
        HStack(spacing: RBHomeFlowLayout.sectionContentSpacing) {
            avatarView

            Text(model.fullName)
                .font(.rb.body14(weight: .semibold))
                .foregroundStyle(Color.rb.textPrimary)
                .lineLimit(1)

            Spacer(minLength: 0)

            ForEach(Array(actions.enumerated()), id: \.offset) { _, action in
                actionButton(action)
            }
        }
    }

    @ViewBuilder
    private var avatarView: some View {
        if let avatarAction = model.avatarAction {
            Button(action: avatarAction) {
                avatarShape
            }
            .buttonStyle(.plain)
        } else {
            avatarShape
        }
    }

    private var avatarShape: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 40, height: 40)
            .overlay {
                Circle()
                    .stroke(Color.rb.separator, lineWidth: 1)
            }
            .overlay {
                Text(model.avatarText)
                    .font(.rb.body14(weight: .semibold))
                    .foregroundStyle(Color.rb.textPrimary)
            }
    }

    private func actionButton(_ action: RBHomeFlowProfileHeaderAction) -> some View {
        Button(action: action.onTap) {
            Circle()
                .fill(Color.white)
                .frame(width: 36, height: 36)
                .overlay {
                    Circle()
                        .stroke(Color.rb.separator, lineWidth: 1)
                }
                .overlay {
                    Image(systemName: action.systemImage)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.rb.textPrimary)
                }
        }
        .buttonStyle(.plain)
    }
}
