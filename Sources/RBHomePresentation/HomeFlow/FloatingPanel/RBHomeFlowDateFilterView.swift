//
//  RBHomeFlowDateFilterView.swift
//  RBDesignSystem
//
//  Displays the active date filter in the transactions panel header.
//  - Preset filters (.today / .thisWeek / .thisMonth): single navigable pill with < > arrows.
//    Navigation is managed internally via an offset; the parent's activeFilter stays as the preset.
//  - Custom date range (.custom): two tappable date chips with chevron-down.
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowDateFilterView: View {
    let filter: RBHomeFlowPanelFilter
    /// Called only to update the ViewModel (transaction filtering). Does NOT update parent's activeFilter.
    let onFilterChange: (RBHomeFlowPanelFilter) -> Void
    /// Called when a date chip is tapped in custom-range mode.
    var onChipTap: (() -> Void)? = nil

    /// Navigation offset relative to the current preset period.
    @State private var offset: Int = 0

    private let calendar = Calendar.current
    private let azLocale = Locale(identifier: "az_AZ")

    var body: some View {
        if case .custom(let from, let to) = filter {
            customChips(from: from, to: to)
        } else {
            presetPill
        }
    }

    // MARK: - Two chips (custom range)

    private func customChips(from: Date, to: Date) -> some View {
        HStack(spacing: 8) {
            dateChip(date: from)
            dateChip(date: to)
        }
        .frame(maxWidth: .infinity)
    }

    private func dateChip(date: Date) -> some View {
        RBDropdownChip(label: formatFullDate(date)) { onChipTap?() }
    }

    // MARK: - Single navigable pill (preset)

    private var presetPill: some View {
        RBNavigablePill(
            label: presetLabel,
            onPrevious: { changeOffset(by: -1) },
            onNext: { changeOffset(by: 1) }
        )
        .onChange(of: filter) { _ in
            offset = 0
        }
    }

    // MARK: - Navigation

    private func changeOffset(by delta: Int) {
        offset += delta
        onFilterChange(computedDateRange)
    }

    /// Date range computed from (base filter + offset). Used both for display and ViewModel filtering.
    private var computedDateRange: RBHomeFlowPanelFilter {
        switch filter {
        case .today:
            let base = calendar.startOfDay(for: Date())
            let day = calendar.date(byAdding: .day, value: offset, to: base)!
            return .custom(from: day, to: day)
        case .thisWeek:
            let base = calendar.date(
                from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
            let start = calendar.date(byAdding: .weekOfYear, value: offset, to: base)!
            let end = calendar.date(byAdding: .day, value: 6, to: start)!
            return .custom(from: start, to: end)
        case .thisMonth:
            let base = calendar.date(
                from: calendar.dateComponents([.year, .month], from: Date()))!
            let start = calendar.date(byAdding: .month, value: offset, to: base)!
            let end = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: start)!
            return .custom(from: start, to: end)
        case .custom(let f, let t):
            return .custom(from: f, to: t)
        }
    }

    // MARK: - Preset label (reflects current offset)

    private var presetLabel: String {
        guard case .custom(let from, let to) = computedDateRange else { return "" }
        switch filter {
        case .today:
            return formatFullDate(from)
        case .thisWeek:
            return formatWeekRange(from: from, to: to)
        case .thisMonth:
            let fmt = DateFormatter()
            fmt.locale = azLocale
            fmt.dateFormat = "MMMM, yyyy"
            return fmt.string(from: from)
        case .custom:
            return ""
        }
    }

    // MARK: - Formatters

    private func formatWeekRange(from: Date, to: Date) -> String {
        let sameMonth = calendar.component(.month, from: from) == calendar.component(.month, from: to)
        let dayStart = calendar.component(.day, from: from)
        let dayEnd = calendar.component(.day, from: to)
        let fmt = DateFormatter()
        fmt.locale = azLocale
        if sameMonth {
            fmt.dateFormat = "MMMM"
            return "\(dayStart) - \(dayEnd) \(fmt.string(from: to))"
        } else {
            fmt.dateFormat = "d MMMM"
            return "\(fmt.string(from: from)) - \(fmt.string(from: to))"
        }
    }

    private func formatFullDate(_ date: Date) -> String {
        let fmt = DateFormatter()
        fmt.locale = azLocale
        fmt.dateFormat = "d MMMM, yyyy"
        return fmt.string(from: date)
    }
}
