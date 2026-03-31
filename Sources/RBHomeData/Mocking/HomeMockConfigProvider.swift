//
//  HomeMockConfigProvider.swift
//  RBHomeData
//
//  Created by Rizvan Rzayev on 31.03.2026.
//

import Foundation
import Networking

public final class HomeMockConfigProvider: MockProviding {
    public init() {}

    public var rules: [MockRule] {
        let bundle = Bundle.module

        return [
            MockRule(
                match: .init(
                    method: .get,
                    path: .contains("accounts/listAllAccounts")
                ),
                scenarios: [
                    "Cards": .jsonFile(name: "home_plastic_cards", bundle: bundle, delayMs: 200),
                    "Accounts": .jsonFile(name: "home_accounts", bundle: bundle, delayMs: 200),
                    "Loans": .jsonFile(name: "home_loans", bundle: bundle, delayMs: 200),
                    "Deposits": .jsonFile(name: "home_deposits", bundle: bundle, delayMs: 200)
                ],
                defaultScenario: "Loans",
                key: "home.accounts.listAllAccounts"
            ),
            MockRule(
                match: .init(
                    method: .get,
                    path: .contains("paymentScheduler/listCreditAccountScheduler")
                ),
                response: .jsonFile(
                    name: "home_loan_schedule",
                    bundle: bundle,
                    delayMs: 200
                )
            ),
            MockRule(
                match: .init(
                    method: .get,
                    path: .contains("accounts/listAccountStatement")
                ),
                response: .jsonFile(
                    name: "home_account_statement",
                    bundle: bundle,
                    delayMs: 200
                )
            ),
            MockRule(
                match: .init(
                    method: .get,
                    path: .contains("plastic/listStatement")
                ),
                response: .jsonFile(
                    name: "home_card_transactions",
                    bundle: bundle,
                    delayMs: 200
                )
            ),
            MockRule(
                match: .init(
                    method: .get,
                    path: .contains("plastic/listCardStorageStatement")
                ),
                response: .jsonFile(
                    name: "home_card_transactions",
                    bundle: bundle,
                    delayMs: 200
                )
            ),
            MockRule(
                match: .init(
                    method: .get,
                    path: .contains("plastic/listPlasticCards")
                ),
                response: .jsonFile(
                    name: "home_plastic_cards",
                    bundle: bundle,
                    delayMs: 200
                )
            ),
            MockRule(
                match: .init(
                    method: .get,
                    path: .contains("plastic/getBonusPoint")
                ),
                response: .jsonFile(
                    name: "home_bonus_points",
                    bundle: bundle,
                    delayMs: 200
                )
            ),
            MockRule(
                match: .init(
                    method: .get,
                    path: .contains("other/getNotificationCount")
                ),
                response: .jsonFile(
                    name: "home_notification_count",
                    bundle: bundle,
                    delayMs: 200
                )
            )
        ]
    }
}
