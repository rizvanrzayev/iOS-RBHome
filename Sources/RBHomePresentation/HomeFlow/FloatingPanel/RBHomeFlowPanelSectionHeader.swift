//
//  RBHomeFlowPanelSectionHeader.swift
//  RBDesignSystem
//
//  Stateful section header for the HomeFlow floating panel.
//  Manages three visual modes: idle, search active, filter active.
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowPanelSectionHeader: View {
    let model: RBHomeFlowPanelModel
    let expand: () -> Void

    @State private var isSearchActive = false
    @State private var searchText = ""
    @State private var activeFilter: RBHomeFlowPanelFilter? = nil

    @EnvironmentObject private var overlayManager: RBOverlayManager

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                if isSearchActive {
                    searchInput
                    closeSearchButton
                } else {
                    titleRow
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)

            if let filter = activeFilter, !isSearchActive {
                filterChipRow(filter: filter)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
            }
        }
    }

    // MARK: - Idle / Filter-active title row

    private var titleRow: some View {
        HStack {
            Text(model.title)
                .font(.rb.body14(weight: .semibold))
                .foregroundStyle(Color.rb.textPrimary)

            Spacer()

            if model.onSearchChange != nil {
                Button {
                    withAnimation { isSearchActive = true }
                    expand()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.rb.textPrimary)
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
            }

            if model.onFilterChange != nil {
                if activeFilter != nil {
                    Button {
                        activeFilter = nil
                        model.onFilterChange?(nil)
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.rb.textPrimary)
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.plain)
                } else {
                    Button {
                        showFilterSheet()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.rb.textPrimary)
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Search bar

    private var searchInput: some View {
        RBSearchField(placeholder: "Axtar...", text: $searchText)
            .onChange(of: searchText) { value in
                model.onSearchChange?(value)
            }
    }

    private var closeSearchButton: some View {
        RBSearchFieldClearButton {
            withAnimation {
                isSearchActive = false
                searchText = ""
            }
            model.onSearchChange?("")
        }
    }

    // MARK: - Filter sheet

    private func showFilterSheet() {
        overlayManager.showSheet(containerStyle: .none) {
            RBHomeFlowPanelFilterSheet(onSelect: { filter in
                activeFilter = filter
                overlayManager.dismissCurrent()
                model.onFilterChange?(filter)
            })
        }
    }

    // MARK: - Filter chip

    private func filterChipRow(filter: RBHomeFlowPanelFilter) -> some View {
        HStack {
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.rb.textSecondary)

                Text(filterDisplayText(filter))
                    .font(.rb.body14())
                    .foregroundStyle(Color.rb.textPrimary)

                Button {
                    activeFilter = nil
                    model.onFilterChange?(nil)
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.rb.textSecondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "#F6F6F9"))
            )

            Spacer()
        }
    }

    // MARK: - Filter display text

    private func filterDisplayText(_ filter: RBHomeFlowPanelFilter) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "dd.MM.yyyy"
        let today = Date()
        switch filter {
        case .today:
            return fmt.string(from: today)
        case .thisWeek:
            let start = Calendar.current.date(from:
                Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
            let end = Calendar.current.date(byAdding: .day, value: 6, to: start)!
            return "\(fmt.string(from: start)) - \(fmt.string(from: end))"
        case .thisMonth:
            let comps = Calendar.current.dateComponents([.year, .month], from: today)
            let start = Calendar.current.date(from: comps)!
            let end = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: start)!
            return "\(fmt.string(from: start)) - \(fmt.string(from: end))"
        case .custom(let from, let to):
            return "\(fmt.string(from: from)) - \(fmt.string(from: to))"
        }
    }
}
