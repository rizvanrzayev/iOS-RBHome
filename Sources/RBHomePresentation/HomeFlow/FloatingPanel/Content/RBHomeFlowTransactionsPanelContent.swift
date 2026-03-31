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
        return AnyView(ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                if let segmentedControl = model.segmentedControl {
                    RBSegmentedControl(
                        selection: Binding(
                            get: { segmentedControl.selectedIndex },
                            set: { segmentedControl.onSelectionChange($0) }
                        ),
                        items: segmentedControl.items
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    .padding(.bottom, model.items.isEmpty ? 0 : 8)
                }

                if model.items.isEmpty {
                    RBEmptyState(title: "Əməliyyat yoxdur", message: nil, layout: .inline)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)
                } else {
                    GeometryReader { geo in
                        Color.clear.preference(
                            key: PanelScrollOffsetKey.self,
                            value: geo.frame(in: .named("panelScroll")).minY
                        )
                    }
                    .frame(height: 0)

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

                        RBTransactionRow(model: .init(
                            id: item.id,
                            title: item.title,
                            subtitle: item.subtitle,
                            amount: isBalanceVisible ? item.amount : "••••",
                            isCredit: item.isCredit,
                            iconURL: item.iconURL,
                            iconColorHex: item.iconColorHex
                        ))

                        if index < model.items.count - 1 {
                            Divider()
                                .padding(.leading, 84)
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 80) }
        .coordinateSpace(name: "panelScroll")
        .onPreferenceChange(PanelScrollOffsetKey.self) { offset in
            if isExpanded && offset > RBHomeFlowLayout.floatingPanelCollapseThreshold {
                collapse()
            }
        }
        .modifier(RBScrollDisabledModifier(disabled: !isExpanded))
        )
    }
}
