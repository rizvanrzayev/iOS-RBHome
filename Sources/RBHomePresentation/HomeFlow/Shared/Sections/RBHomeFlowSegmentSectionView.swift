//
//  RBHomeFlowSegmentSectionView.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 13.03.2026.
//

import SwiftUI
import RBDesignSystem

struct RBHomeFlowSegmentSectionView: View {
    @Binding var selection: RBHomeFlowSegment

    private var segmentItems: [RBHomeFlowSegment] {
        RBHomeFlowSegment.allCases
    }

    private var selectionIndex: Binding<Int> {
        Binding(
            get: { selection.rawValue },
            set: { newValue in
                let clamped = max(0, min(newValue, segmentItems.count - 1))
                selection = segmentItems[clamped]
            }
        )
    }

    var body: some View {
        RBSegmentedControl(
            selection: selectionIndex,
            items: segmentItems.map(\.title)
        )
    }
}
