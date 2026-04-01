//
//  HomeCardDetailSectionContext.swift
//  RBHomeDomain
//
//  Created by Rizvan Rzayev on 01.04.2026.
//

public struct HomeCardDetailSectionContext: Sendable {
    public let sectionID: Int
    public let cardIdn: Int
    public let cardName: String
    public let maskedPan: String
    public let currency: String
    public let iban: String?
    public let isLocked: Bool
    public let isRecharge: Bool
    public let cardType: HomeCardType
    public let cardDetectionTypeRaw: Int
    public let token: String?
    public let isJunior: Bool
    public let isInstallmentCard: Bool
    public let isAdvanceLoan: Bool
    public let hasTurnover: Bool

    public init(
        sectionID: Int,
        cardIdn: Int,
        cardName: String,
        maskedPan: String,
        currency: String,
        iban: String?,
        isLocked: Bool,
        isRecharge: Bool,
        cardType: HomeCardType,
        cardDetectionTypeRaw: Int,
        token: String?,
        isJunior: Bool,
        isInstallmentCard: Bool,
        isAdvanceLoan: Bool,
        hasTurnover: Bool
    ) {
        self.sectionID = sectionID
        self.cardIdn = cardIdn
        self.cardName = cardName
        self.maskedPan = maskedPan
        self.currency = currency
        self.iban = iban
        self.isLocked = isLocked
        self.isRecharge = isRecharge
        self.cardType = cardType
        self.cardDetectionTypeRaw = cardDetectionTypeRaw
        self.token = token
        self.isJunior = isJunior
        self.isInstallmentCard = isInstallmentCard
        self.isAdvanceLoan = isAdvanceLoan
        self.hasTurnover = hasTurnover
    }
}
