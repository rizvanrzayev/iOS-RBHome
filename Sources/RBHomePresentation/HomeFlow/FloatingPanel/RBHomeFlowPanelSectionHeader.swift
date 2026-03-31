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
    let collapse: () -> Void

    @State private var isSearchActive = false
    @State private var searchText = ""
    @State private var activeFilter: RBHomeFlowPanelFilter? = nil
    @State private var searchFocused = false

    // Wheel picker state for direct chip editing (custom date range)
    @State private var editingDateKind: EditingDateKind? = nil
    @State private var pickerDate: Date = Date()

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
                RBHomeFlowDateFilterView(
                    filter: filter,
                    onFilterChange: { newFilter in
                        model.onFilterChange?(newFilter)
                    },
                    onChipTap: { openWheelPicker(kind: .from) },
                    onToChipTap: { openWheelPicker(kind: .to) }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
            }
        }
        .sheet(item: $editingDateKind) { kind in
            if #available(iOS 16.0, *) {
                RBWheelPickerSheet(
                    title: kind == .from ? "Başlanğıc tarixi" : "Son tarix",
                    selection: $pickerDate,
                    onDone: { commitPickerEdit(kind: kind) }
                )
                .presentationDetents([.height(350)])
            } else {
                RBWheelPickerSheet(
                    title: kind == .from ? "Başlanğıc tarixi" : "Son tarix",
                    selection: $pickerDate,
                    onDone: { commitPickerEdit(kind: kind) }
                )
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
                RBIconButton(icon: .iconSearch) {
                    isSearchActive = true
                    searchFocused = true
                    expand()
                }
            }

            if model.onFilterChange != nil {
                if activeFilter != nil {
                    RBIconButton(icon: .xmark) {
                        activeFilter = nil
                        model.onFilterChange?(nil)
                        collapse()
                    }
                } else {
                    RBIconButton(icon: .iconFilter) {
                        showFilterSheet()
                    }
                }
            }
        }
    }

    // MARK: - Search bar

    private var searchInput: some View {
        RBSearchField(placeholder: "Axtar...", text: $searchText, isFocused: $searchFocused)
            .onChange(of: searchText) { value in
                model.onSearchChange?(value)
            }
    }

    private var closeSearchButton: some View {
        RBSearchFieldClearButton {
            isSearchActive = false
            searchFocused = false
            searchText = ""
            model.onSearchChange?("")
            collapse()
        }
    }

    // MARK: - Filter sheet

    private func showFilterSheet() {
        overlayManager.showSheet(
            containerStyle: .default(
                title: "Razılaşdırma tarixi",
                showsHandle: true,
                showsClose: true,
                contentPadding: 24
            )
        ) {
            RBHomeFlowPanelFilterSheet(
                onSelect: { filter in
                    activeFilter = filter
                    overlayManager.dismissCurrent()
                    model.onFilterChange?(filter)
                    expand()
                },
                onCustomDate: {
                    overlayManager.dismissCurrent()
                    showDatePicker()
                }
            )
        }
    }

    // MARK: - Full date range picker (overlay, for preset pill label tap)

    private func showDatePicker() {
        let currentFrom: Date
        let currentTo: Date
        if case .custom(let f, let t) = activeFilter {
            currentFrom = f
            currentTo = t
        } else {
            currentFrom = Date()
            currentTo = Date()
        }
        overlayManager.showSheet(
            containerStyle: .default(
                title: "Tarix seçin",
                showsHandle: true,
                showsClose: true,
                contentPadding: 24
            )
        ) {
            RBHomeFlowSingleDateSheet(from: currentFrom, to: currentTo) { filter in
                activeFilter = filter
                overlayManager.dismissCurrent()
                model.onFilterChange?(filter)
            }
        }
    }

    // MARK: - Wheel picker (direct chip tap in custom range mode)

    private func openWheelPicker(kind: EditingDateKind) {
        if case .custom(let f, let t) = activeFilter {
            pickerDate = kind == .from ? f : t
        } else {
            pickerDate = Date()
        }
        editingDateKind = kind
    }

    private func commitPickerEdit(kind: EditingDateKind) {
        guard case .custom(let f, let t) = activeFilter else { return }
        let newFilter: RBHomeFlowPanelFilter = kind == .from
            ? .custom(from: pickerDate, to: t)
            : .custom(from: f, to: pickerDate)
        activeFilter = newFilter
        model.onFilterChange?(newFilter)
        editingDateKind = nil
    }
}

// MARK: - Helpers

private enum EditingDateKind: Identifiable {
    case from, to
    var id: String { self == .from ? "from" : "to" }
}
