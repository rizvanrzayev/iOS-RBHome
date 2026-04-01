//
//  Array+Chunked.swift
//  RBHomePresentation
//
//  Created by Rizvan Rzayev on 01.04.2026.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0, isEmpty == false else { return [] }

        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
