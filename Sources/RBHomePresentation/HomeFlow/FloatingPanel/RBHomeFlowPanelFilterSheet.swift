//
//  RBHomeFlowPanelFilterSheet.swift
//  RBHomePresentation
//
//  Plain preset-list content for the filter bottom sheet.
//  Container (title, handle, close) is provided by the overlay manager's containerStyle.
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowPanelFilterSheet: View {
    let onSelect: (RBHomeFlowPanelFilter) -> Void
    var onCustomDate: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            filterRow(title: "Bu Gün") { onSelect(.today) }
            Divider().padding(.leading, 20)
            filterRow(title: "Bu Həftə") { onSelect(.thisWeek) }
            Divider().padding(.leading, 20)
            filterRow(title: "Bu Ay") { onSelect(.thisMonth) }
            Divider().padding(.leading, 20)
            filterRow(title: "Seçilmiş tarix") { onCustomDate?() }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func filterRow(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.rb.body(weight: .regular))
                    .foregroundStyle(Color.rb.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.rb.textSecondary)
            }
            .padding(.vertical, 18)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Date range picker sheet content

struct RBHomeFlowSingleDateSheet: View {
    let onSelect: (RBHomeFlowPanelFilter) -> Void

    @State private var fromDate: Date
    @State private var toDate: Date

    init(from: Date = Date(), to: Date = Date(), onSelect: @escaping (RBHomeFlowPanelFilter) -> Void) {
        self._fromDate = State(initialValue: from)
        self._toDate = State(initialValue: to)
        self.onSelect = onSelect
    }

    var body: some View {
        VStack(spacing: 16) {
            RBDatePicker("Başlanğıc tarixi", selection: $fromDate)
            RBDatePicker("Son tarix", selection: $toDate)
            RBButton("Tətbiq et") {
                onSelect(.custom(from: fromDate, to: toDate))
            }
        }
        .padding(.bottom, 8)
    }
}
