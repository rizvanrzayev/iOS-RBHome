//
//  RBHomeFlowTransactionsPanelContent.swift
//  RBDesignSystem
//
//  Standalone content view for the transactions variant of the HomeFlow floating panel.
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowTransactionsPanelContent: View {
    let state: RBHomeFlowSectionState<RBHomeFlowPanelModel>
    let isExpanded: Bool
    let collapse: () -> Void
    var isBalanceVisible: Bool = true

    var body: some View {
        switch state {
        case .loading:
            RBHomeFlowTransactionsSkeleton()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded(let model):
            loadedScrollView(model: model)
        case .empty(let title, let message):
            RBEmptyState(title: title, message: message, layout: .inline)
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
        case .error(let title, let message):
            RBEmptyState(title: title, message: message, layout: .inline)
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
        }
    }

    private func loadedScrollView(model: RBHomeFlowPanelModel) -> some View {
        return AnyView(RBHomeFlowPanCoordinatedScrollView(
            isExpanded: isExpanded,
            coordinateSpaceName: "panelScroll",
            bottomInset: 80
        ) {
            LazyVStack(alignment: .leading, spacing: 0) {
                if let segmentedControl = model.segmentedControl {
                    panelSegmentedControl(segmentedControl)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                        .padding(.bottom, model.items.isEmpty ? 0 : 8)
                }

                if model.items.isEmpty {
                    RBEmptyState(title: "Əməliyyat yoxdur", message: nil, layout: .inline)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)
                } else {
                    ForEach(Array(model.items.enumerated()), id: \.element.id) { index, item in
                        let showsDateHeader = item.date != nil &&
                            (index == 0 || item.date != model.items[index - 1].date)

                        if showsDateHeader, let date = item.date {
                            Text(date)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(Color.rb.textSecondary)
                                .padding(.horizontal, 24)
                                .padding(.top, index == 0 ? 8 : 16)
                                .padding(.bottom, 8)
                        }

                        RBHomeFlowSwipeableTransactionRow(actions: item.swipeActions) {
                            RBTransactionRow(model: .init(
                                id: item.id,
                                title: item.title,
                                subtitle: item.subtitle,
                                amount: isBalanceVisible ? item.amount : "••••",
                                isCredit: item.isCredit,
                                iconURL: item.iconURL,
                                iconColorHex: item.iconColorHex
                            ))
                        }

                        if index < model.items.count - 1 {
                            Divider()
                                .padding(.leading, 84)
                        }
                    }
                }
            }
        })
    }

    @ViewBuilder
    private func panelSegmentedControl(_ model: RBHomeFlowSegmentedControlModel) -> some View {
        switch model.style {
        case .default:
            RBSegmentedControl(
                selection: Binding(
                    get: { model.selectedIndex },
                    set: { model.onSelectionChange($0) }
                ),
                items: model.items
            )
        case .accent:
            RBHomeFlowAccentSegmentedControl(
                selection: Binding(
                    get: { model.selectedIndex },
                    set: { model.onSelectionChange($0) }
                ),
                items: model.items
            )
        }
    }
}

private struct RBHomeFlowAccentSegmentedControl: View {
    @Binding var selection: Int
    let items: [String]

    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geometry in
                let segmentWidth = geometry.size.width / CGFloat(max(items.count, 1))

                Capsule()
                    .fill(Color.rb.selectionGreen)
                    .frame(width: max(segmentWidth - 4, 0), height: 32)
                    .offset(x: CGFloat(selection) * segmentWidth + 2, y: 2)
                    .animation(.spring(response: 0.3, dampingFraction: 0.75), value: selection)
            }

            HStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, title in
                    Button {
                        selection = index
                        RBHaptic.trigger(.light)
                    } label: {
                        Text(title)
                            .font(.rb.subtitle())
                            .fontWeight(selection == index ? .semibold : .regular)
                            .foregroundStyle(selection == index ? Color.white : Color.rb.textSecondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 32)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(height: 36)
        .background(Color.rb.backgroundSecondary)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.rb.separator, lineWidth: 1)
        )
    }
}
