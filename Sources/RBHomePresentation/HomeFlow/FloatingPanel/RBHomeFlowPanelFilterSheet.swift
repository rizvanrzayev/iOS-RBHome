//
//  RBHomeFlowPanelFilterSheet.swift
//  RBDesignSystem
//
//  Filter bottom sheet for the HomeFlow transactions panel.
//  Presents preset date filters and a custom date range picker.
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowPanelFilterSheet: View {
    let onSelect: (RBHomeFlowPanelFilter) -> Void

    @State private var showingCustomPicker = false
    @State private var startDate = Date()
    @State private var endDate = Date()

    var body: some View {
        RBBottomSheetContentContainer(
            title: showingCustomPicker ? "Seçilmiş tarix" : "Razılaşdırma tarixi",
            showsHandle: true,
            showsClose: false,
            contentPadding: 16
        ) {
            if showingCustomPicker {
                customPickerContent
            } else {
                presetListContent
            }
        }
    }

    // MARK: - Preset list

    private var presetListContent: some View {
        VStack(spacing: 8) {
            RBActionRow(model: RBActionRowModel(
                id: "today",
                icon: .iconActivity,
                title: "Bu gün",
                description: "",
                onTap: { onSelect(.today) }
            ))

            RBActionRow(model: RBActionRowModel(
                id: "thisWeek",
                icon: .iconMoneyTime,
                title: "Bu həftə",
                description: "",
                onTap: { onSelect(.thisWeek) }
            ))

            RBActionRow(model: RBActionRowModel(
                id: "thisMonth",
                icon: .iconDiscount,
                title: "Bu ay",
                description: "",
                onTap: { onSelect(.thisMonth) }
            ))

            RBActionRow(model: RBActionRowModel(
                id: "custom",
                icon: .iconFilter,
                title: "Seçilmiş tarix",
                description: "",
                onTap: { withAnimation { showingCustomPicker = true } }
            ))
        }
    }

    // MARK: - Custom date picker

    private var customPickerContent: some View {
        VStack(spacing: 16) {
            RBDatePicker("Başlanğıc tarixi", selection: $startDate)
            RBDatePicker("Son tarix", selection: $endDate)

            RBButton("Tətbiq et") {
                onSelect(.custom(from: startDate, to: endDate))
            }
        }
    }
}
