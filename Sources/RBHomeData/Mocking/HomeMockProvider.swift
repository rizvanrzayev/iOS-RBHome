//
//  HomeMockProvider.swift
//  RBHomeData
//
//  Created by Rizvan Rzayev on 31.03.2026.
//

import Networking

public struct HomeMockProvider: MockModuleProvider {
    public let key = "home"

    public init() {}

    public func rules() -> [MockRule] {
        HomeMockConfigProvider().rules
    }
}
