//
//  HomeCardTransactionActionPayload.swift
//  RBHomeDomain
//
//  Created by Rizvan Rzayev on 31.03.2026.
//

import Foundation

public struct HomeCardTransactionActionPayload: Sendable {
    public let localDate: Date
    public let statementDescription: String?
    public let descriptionExtended: String?
    public let amount: Double
    public let currency: String
    public let accountAmount: Double
    public let accountCurrency: String
    public let rrn: String?
    public let srn: String?
    public let arn: String?
    public let country: String?
    public let city: String?
    public let mcc: String?
    public let cardIdn: Int?
    public let authCode: String?
    public let transCondition: String?
    public let fee: Double?
    public let feeCurrency: String?
    public let transactionStatus: String?
    public let rechargeOrderStatus: String?
    public let isChargebackEligible: Bool

    public init(
        localDate: Date,
        statementDescription: String?,
        descriptionExtended: String?,
        amount: Double,
        currency: String,
        accountAmount: Double,
        accountCurrency: String,
        rrn: String? = nil,
        srn: String? = nil,
        arn: String? = nil,
        country: String? = nil,
        city: String? = nil,
        mcc: String? = nil,
        cardIdn: Int? = nil,
        authCode: String? = nil,
        transCondition: String? = nil,
        fee: Double? = nil,
        feeCurrency: String? = nil,
        transactionStatus: String? = nil,
        rechargeOrderStatus: String? = nil,
        isChargebackEligible: Bool = false
    ) {
        self.localDate = localDate
        self.statementDescription = statementDescription
        self.descriptionExtended = descriptionExtended
        self.amount = amount
        self.currency = currency
        self.accountAmount = accountAmount
        self.accountCurrency = accountCurrency
        self.rrn = rrn
        self.srn = srn
        self.arn = arn
        self.country = country
        self.city = city
        self.mcc = mcc
        self.cardIdn = cardIdn
        self.authCode = authCode
        self.transCondition = transCondition
        self.fee = fee
        self.feeCurrency = feeCurrency
        self.transactionStatus = transactionStatus
        self.rechargeOrderStatus = rechargeOrderStatus
        self.isChargebackEligible = isChargebackEligible
    }
}
