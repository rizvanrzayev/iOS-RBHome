//
//  RBHomeFlowPageModels.swift
//  RBDesignSystem
//
//  Created by Rizvan Rzayev on 12.03.2026.
//

import Foundation
import SwiftUI
import RBDesignSystem

// MARK: - Segment Home Models

public struct RBHomeFlowCardHomeModel {
    public let cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel>
    public let quickActionsState: RBHomeFlowSectionState<RBHomeFlowQuickActionsModel>
    public let bonusSectionState: RBHomeFlowSectionState<RBHomeFlowCardBonusSection>
    public let panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel>

    public init(
        cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel>,
        quickActionsState: RBHomeFlowSectionState<RBHomeFlowQuickActionsModel>,
        bonusSectionState: RBHomeFlowSectionState<RBHomeFlowCardBonusSection>,
        panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel> = .loading
    ) {
        self.cardsState = cardsState
        self.quickActionsState = quickActionsState
        self.bonusSectionState = bonusSectionState
        self.panelState = panelState
    }
}

public struct RBHomeFlowCardDetailModel {
    public let title: String
    public let cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel>
    public let quickActionsState: RBHomeFlowSectionState<RBHomeFlowQuickActionsModel>
    public let actionsState: RBHomeFlowSectionState<RBHomeFlowDetailActionsModel>

    public init(
        title: String,
        cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel>,
        quickActionsState: RBHomeFlowSectionState<RBHomeFlowQuickActionsModel>,
        actionsState: RBHomeFlowSectionState<RBHomeFlowDetailActionsModel>
    ) {
        self.title = title
        self.cardsState = cardsState
        self.quickActionsState = quickActionsState
        self.actionsState = actionsState
    }
}

public struct RBHomeFlowAccountHomeModel {
    public let cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel>
    public let actionsState: RBHomeFlowSectionState<RBHomeFlowQuickActionsModel>
    public let operationsState: RBHomeFlowSectionState<RBHomeFlowInfoListModel>
    public let panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel>

    public init(
        cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel>,
        actionsState: RBHomeFlowSectionState<RBHomeFlowQuickActionsModel>,
        operationsState: RBHomeFlowSectionState<RBHomeFlowInfoListModel>,
        panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel> = .loading
    ) {
        self.cardsState = cardsState
        self.actionsState = actionsState
        self.operationsState = operationsState
        self.panelState = panelState
    }
}

public struct RBHomeFlowAccountDetailModel {
    public let title: String
    public let cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel>
    public let infoState: RBHomeFlowSectionState<RBHomeFlowInfoListModel>
    public let actionsState: RBHomeFlowSectionState<RBHomeFlowDetailActionsModel>
    public let panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel>

    public init(
        title: String,
        cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel>,
        infoState: RBHomeFlowSectionState<RBHomeFlowInfoListModel>,
        actionsState: RBHomeFlowSectionState<RBHomeFlowDetailActionsModel>,
        panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel> = .loading
    ) {
        self.title = title
        self.cardsState = cardsState
        self.infoState = infoState
        self.actionsState = actionsState
        self.panelState = panelState
    }
}

public struct RBHomeFlowLoanHomeModel {
    public let cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel>
    public let actionsState: RBHomeFlowSectionState<RBHomeFlowQuickActionsModel>
    public let scheduleState: RBHomeFlowSectionState<RBHomeFlowInfoListModel>
    public let panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel>

    public init(
        cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel>,
        actionsState: RBHomeFlowSectionState<RBHomeFlowQuickActionsModel>,
        scheduleState: RBHomeFlowSectionState<RBHomeFlowInfoListModel>,
        panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel> = .loading
    ) {
        self.cardsState = cardsState
        self.actionsState = actionsState
        self.scheduleState = scheduleState
        self.panelState = panelState
    }
}

public struct RBHomeFlowLoanDetailModel {
    public let title: String
    public let cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel>
    public let scheduleState: RBHomeFlowSectionState<RBHomeFlowInfoListModel>
    public let actionsState: RBHomeFlowSectionState<RBHomeFlowDetailActionsModel>
    public let panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel>

    public init(
        title: String,
        cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel>,
        scheduleState: RBHomeFlowSectionState<RBHomeFlowInfoListModel>,
        actionsState: RBHomeFlowSectionState<RBHomeFlowDetailActionsModel>,
        panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel> = .loading
    ) {
        self.title = title
        self.cardsState = cardsState
        self.scheduleState = scheduleState
        self.actionsState = actionsState
        self.panelState = panelState
    }
}

public struct RBHomeFlowDepositHomeModel {
    public let cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel>
    public let actionsState: RBHomeFlowSectionState<RBHomeFlowQuickActionsModel>
    public let conditionsState: RBHomeFlowSectionState<RBHomeFlowInfoListModel>
    public let panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel>

    public init(
        cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel>,
        actionsState: RBHomeFlowSectionState<RBHomeFlowQuickActionsModel>,
        conditionsState: RBHomeFlowSectionState<RBHomeFlowInfoListModel>,
        panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel> = .loading
    ) {
        self.cardsState = cardsState
        self.actionsState = actionsState
        self.conditionsState = conditionsState
        self.panelState = panelState
    }
}

public struct RBHomeFlowDepositDetailModel {
    public let title: String
    public let cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel>
    public let conditionsState: RBHomeFlowSectionState<RBHomeFlowInfoListModel>
    public let actionsState: RBHomeFlowSectionState<RBHomeFlowDetailActionsModel>
    public let panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel>

    public init(
        title: String,
        cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel>,
        conditionsState: RBHomeFlowSectionState<RBHomeFlowInfoListModel>,
        actionsState: RBHomeFlowSectionState<RBHomeFlowDetailActionsModel>,
        panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel> = .loading
    ) {
        self.title = title
        self.cardsState = cardsState
        self.conditionsState = conditionsState
        self.actionsState = actionsState
        self.panelState = panelState
    }
}

// MARK: - Segment Payloads

public enum RBHomeFlowSegmentHomeContent {
    case card(RBHomeFlowCardHomeModel)
    case account(RBHomeFlowAccountHomeModel)
    case credit(RBHomeFlowLoanHomeModel)
    case deposit(RBHomeFlowDepositHomeModel)

    var cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel> {
        switch self {
        case .card(let m):   return m.cardsState
        case .account(let m):  return m.cardsState
        case .credit(let m): return m.cardsState
        case .deposit(let m): return m.cardsState
        }
    }

    var panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel> {
        switch self {
        case .card(let m):   return m.panelState
        case .account(let m):  return m.panelState
        case .credit(let m): return m.panelState
        case .deposit(let m): return m.panelState
        }
    }
}

public enum RBHomeFlowSegmentDetailContent {
    case card(RBHomeFlowCardDetailModel)
    case account(RBHomeFlowAccountDetailModel)
    case credit(RBHomeFlowLoanDetailModel)
    case deposit(RBHomeFlowDepositDetailModel)

    var title: String {
        switch self {
        case .card(let m):   return m.title
        case .account(let m):  return m.title
        case .credit(let m): return m.title
        case .deposit(let m): return m.title
        }
    }

    var panelState: RBHomeFlowSectionState<RBHomeFlowPanelModel> {
        switch self {
        case .card:          return .loading
        case .account(let m):  return m.panelState
        case .credit(let m): return m.panelState
        case .deposit(let m): return m.panelState
        }
    }

    var actionsState: RBHomeFlowSectionState<RBHomeFlowDetailActionsModel> {
        switch self {
        case .card(let m):   return m.actionsState
        case .account(let m):  return m.actionsState
        case .credit(let m): return m.actionsState
        case .deposit(let m): return m.actionsState
        }
    }
}

public struct RBHomeFlowSegmentPayload {
    public let home: RBHomeFlowSegmentHomeContent
    public let detail: RBHomeFlowSegmentDetailContent

    public init(home: RBHomeFlowSegmentHomeContent, detail: RBHomeFlowSegmentDetailContent) {
        self.home = home
        self.detail = detail
    }
}

// MARK: - Page Data

public struct RBHomeFlowPageData {
    public let profileHeaderState: RBHomeFlowSectionState<RBHomeFlowProfileHeaderModel>
    public let segmentPayloads: [RBHomeFlowSegment: RBHomeFlowSegmentPayload]

    public init(
        profileHeaderState: RBHomeFlowSectionState<RBHomeFlowProfileHeaderModel>,
        segmentPayloads: [RBHomeFlowSegment: RBHomeFlowSegmentPayload]
    ) {
        self.profileHeaderState = profileHeaderState

        var resolved = [RBHomeFlowSegment: RBHomeFlowSegmentPayload]()
        for segment in RBHomeFlowSegment.allCases {
            resolved[segment] = segmentPayloads[segment] ?? .placeholder(for: segment)
        }
        self.segmentPayloads = resolved
    }

    public init(
        detailTitle: String,
        profileHeaderState: RBHomeFlowSectionState<RBHomeFlowProfileHeaderModel>,
        cardsState: RBHomeFlowSectionState<RBHomeFlowCarouselModel>,
        homeQuickActionsState: RBHomeFlowSectionState<RBHomeFlowQuickActionsModel>,
        detailQuickActionsState: RBHomeFlowSectionState<RBHomeFlowQuickActionsModel>,
        bonusSectionState: RBHomeFlowSectionState<RBHomeFlowCardBonusSection>,
        detailActionsState: RBHomeFlowSectionState<RBHomeFlowDetailActionsModel>
    ) {
        let cardHome = RBHomeFlowCardHomeModel(
            cardsState: cardsState,
            quickActionsState: homeQuickActionsState,
            bonusSectionState: bonusSectionState
        )
        let cardDetail = RBHomeFlowCardDetailModel(
            title: detailTitle,
            cardsState: cardsState,
            quickActionsState: detailQuickActionsState,
            actionsState: detailActionsState
        )
        self.init(
            profileHeaderState: profileHeaderState,
            segmentPayloads: [.card: .init(home: .card(cardHome), detail: .card(cardDetail))]
        )
    }
}

// MARK: - Page Data Placeholder

public extension RBHomeFlowPageData {
    static var placeholder: RBHomeFlowPageData {
        RBHomeFlowPageData(
            profileHeaderState: .loaded(
                .init(
                    avatarText: "RS",
                    fullName: "Rəşad Süleymanov"
                )
            ),
            segmentPayloads: [
                .card: .placeholder(for: .card),
                .account: .placeholder(for: .account),
                .credit: .placeholder(for: .credit),
                .deposit: .placeholder(for: .deposit)
            ]
        )
    }
}

// MARK: - Placeholders

public extension RBHomeFlowSegmentPayload {
    static func placeholder(for segment: RBHomeFlowSegment) -> RBHomeFlowSegmentPayload {
        switch segment {
        case .card:    return cardPlaceholder
        case .account: return accountPlaceholder
        case .credit:  return creditPlaceholder
        case .deposit: return depositPlaceholder
        }
    }
}

// MARK: - Card Placeholder

private extension RBHomeFlowSegmentPayload {
    static var cardPlaceholder: RBHomeFlowSegmentPayload {
        let carousel = RBHomeFlowCarouselModel(items: [
            .init(id: "card-1", title: "RabCard Visa", subtitle: "**** 4521", amount: "2 845,60 ₼"),
            .init(id: "card-2", title: "Əmək haqqı kartı", subtitle: "**** 8832", amount: "640,00 ₼"),
            .init(id: "card-3", title: "Dollar kartı", subtitle: "**** 1107", amount: "320,15 $")
        ])
        let homeActions = RBHomeFlowQuickActionsModel(items: [
            .init(id: "a1", title: "Köçürmə", icon: .custom(.actionTransfer), onTap: {}),
            .init(id: "a2", title: "Ödəniş", icon: .custom(.actionPayment), onTap: {}),
            .init(id: "a3", title: "Tarix", icon: .system("clock"), onTap: {}),
            .init(id: "a4", title: "Digər", icon: .system("ellipsis.circle"), onTap: {})
        ])
        let bonusSection = RBHomeFlowCardBonusSection.pair(
            RBHomeFlowRefundPairModel(
                leading: RBHomeFlowEDVRefundModel(
                    icon: .iconBonus,
                    title: "Bonuslarım",
                    titleColor: .rb.green,
                    content: .data(amount: "1 240 xal", detail: "Gözlənilən: 320 xal"),
                    onTap: {}
                ),
                trailing: RBHomeFlowEDVRefundModel(
                    icon: .iconEdv,
                    title: "ƏDV geri al",
                    titleColor: .rb.edvBlue,
                    content: .data(amount: "28,40 ₼", detail: "Gözlənilən: 10,80 ₼"),
                    onTap: {}
                )
            )
        )
        let panel = RBHomeFlowPanelModel(title: "Son əməliyyatlar", items: [
            .init(id: "t1", date: "Bu gün", title: "Bolt", subtitle: "Taksi", amount: "-4,20 ₼", isCredit: false),
            .init(id: "t2", date: "Bu gün", title: "Bravo Supermarket", subtitle: "Alış-veriş", amount: "-18,75 ₼", isCredit: false),
            .init(id: "t3", date: "Dünən", title: "Əmək haqqı", subtitle: "Köçürmə", amount: "+1 200,00 ₼", isCredit: true),
            .init(id: "t4", date: "Dünən", title: "Netflix", subtitle: "Abunəlik", amount: "-9,99 $", isCredit: false),
            .init(id: "t5", date: "14 mart", title: "Wolt", subtitle: "Çatdırılma", amount: "-12,50 ₼", isCredit: false),
            .init(id: "t6", date: "14 mart", title: "BP Fuel", subtitle: "Yanacaq", amount: "-45,00 ₼", isCredit: false)
        ])

        let detailActions = RBHomeFlowQuickActionsModel(items: [
            .init(id: "da1", title: "Köçürmə", icon: .custom(.actionTransfer), onTap: {}),
            .init(id: "da2", title: "Ödəniş", icon: .custom(.actionPayment), onTap: {}),
            .init(id: "da3", title: "Bloklama", icon: .system("lock.fill"), onTap: {}),
            .init(id: "da4", title: "Limit", icon: .system("slider.horizontal.3"), onTap: {})
        ])
        let detailActionItems = RBHomeFlowDetailActionsModel(title: "Kart xidmətləri", items: [
            .init(id: "s1", title: "Kartı blokla", description: "Müvəqqəti istifadəni dayandır", systemImage: "lock.fill", onTap: {}),
            .init(id: "s2", title: "Limit idarəetməsi", description: "Gündəlik xərcləmə limitini dəyiş", systemImage: "slider.horizontal.3", onTap: {}),
            .init(id: "s3", title: "Kart rekvizitləri", description: "Tam kart məlumatlarını gör", systemImage: "doc.text.fill", onTap: {}),
            .init(id: "s4", title: "Çıxarış sifariş et", description: "Hesab çıxarışını yüklə", systemImage: "arrow.down.doc.fill", onTap: {})
        ])

        return .init(
            home: .card(.init(
                cardsState: .loaded(carousel),
                quickActionsState: .loaded(homeActions),
                bonusSectionState: .loaded(bonusSection),
                panelState: .loaded(panel)
            )),
            detail: .card(.init(
                title: "RabCard Visa",
                cardsState: .loaded(carousel),
                quickActionsState: .loaded(detailActions),
                actionsState: .loaded(detailActionItems)
            ))
        )
    }
}

// MARK: - Account Placeholder

private extension RBHomeFlowSegmentPayload {
    static var accountPlaceholder: RBHomeFlowSegmentPayload {
        let carousel = RBHomeFlowCarouselModel(items: [
            .init(id: "acc-1", title: "Əsas hesab", subtitle: "AZ21 RABB 0000 0000 1234 5678", amount: "5 320,00 ₼"),
            .init(id: "acc-2", title: "Dollar hesabı", subtitle: "AZ21 RABB 0000 0000 9876 5432", amount: "1 050,00 $"),
            .init(id: "acc-3", title: "Əmanət hesabı", subtitle: "AZ21 RABB 0000 0000 5544 3322", amount: "10 000,00 ₼")
        ])
        let homeActions = RBHomeFlowQuickActionsModel(items: [
            .init(id: "a1", title: "Köçürmə", icon: .system("arrow.left.arrow.right"), onTap: {}),
            .init(id: "a2", title: "Doldur", icon: .system("plus.circle.fill"), onTap: {}),
            .init(id: "a3", title: "Çevir", icon: .system("arrow.2.circlepath"), onTap: {}),
            .init(id: "a4", title: "Çıxarış", icon: .system("doc.text"), onTap: {})
        ])
        let operations = RBHomeFlowInfoListModel(title: "Son əməliyyatlar", items: [
            .init(id: "o1", title: "Köçürmə", subtitle: "Nicat Əliyev", value: "-200,00 ₼"),
            .init(id: "o2", title: "Hesaba daxilolma", subtitle: "Əmək haqqı", value: "+2 400,00 ₼"),
            .init(id: "o3", title: "Kommunal ödənişi", subtitle: "Azərenerji", value: "-34,50 ₼"),
            .init(id: "o4", title: "Xarici köçürmə", subtitle: "Western Union", value: "-150,00 $")
        ])
        let panel = RBHomeFlowPanelModel(title: "Əməliyyatlar", items: [
            .init(id: "t1", date: "Bu gün", title: "Köçürmə", subtitle: "Nicat Əliyev", amount: "-200,00 ₼", isCredit: false),
            .init(id: "t2", date: "Bu gün", title: "Hesaba daxilolma", subtitle: "Əmək haqqı", amount: "+2 400,00 ₼", isCredit: true),
            .init(id: "t3", date: "Dünən", title: "Kommunal ödənişi", subtitle: "Azərenerji", amount: "-34,50 ₼", isCredit: false),
            .init(id: "t4", date: "Dünən", title: "Xarici köçürmə", subtitle: "Western Union", amount: "-150,00 $", isCredit: false),
            .init(id: "t5", date: "14 mart", title: "Bank faizi", subtitle: "Aylıq gəlir", amount: "+12,80 ₼", isCredit: true)
        ])

        let detailInfo = RBHomeFlowInfoListModel(title: "Hesab məlumatları", items: [
            .init(id: "i1", title: "IBAN", value: "AZ21 RABB 0000 0000 1234 5678"),
            .init(id: "i2", title: "Valyuta", value: "AZN (₼)"),
            .init(id: "i3", title: "Filial", value: "Baş ofis, Bakı"),
            .init(id: "i4", title: "SWIFT", value: "RABBAZ22"),
            .init(id: "i5", title: "Açılış tarixi", value: "12.01.2022")
        ])
        let detailActionItems = RBHomeFlowDetailActionsModel(title: "Hesab xidmətləri", items: [
            .init(id: "s1", title: "Rekvizitlər", description: "Hesab rekvizitlərini paylaş", systemImage: "doc.text.fill", onTap: {}),
            .init(id: "s2", title: "Çıxarış", description: "Hesab çıxarışını yüklə", systemImage: "arrow.down.doc.fill", onTap: {}),
            .init(id: "s3", title: "Köçürmə", description: "Hesabdan köçürmə et", systemImage: "arrow.left.arrow.right", onTap: {}),
            .init(id: "s4", title: "Hesabı bağla", description: "Hesabı bağlamaq üçün müraciət et", systemImage: "xmark.circle.fill", onTap: {})
        ])

        return .init(
            home: .account(.init(
                cardsState: .loaded(carousel),
                actionsState: .loaded(homeActions),
                operationsState: .loaded(operations),
                panelState: .loaded(panel)
            )),
            detail: .account(.init(
                title: "Əsas hesab",
                cardsState: .loaded(carousel),
                infoState: .loaded(detailInfo),
                actionsState: .loaded(detailActionItems),
                panelState: .loaded(panel)
            ))
        )
    }
}

// MARK: - Credit Placeholder

private extension RBHomeFlowSegmentPayload {
    static var creditPlaceholder: RBHomeFlowSegmentPayload {
        let carousel = RBHomeFlowCarouselModel(items: [
            .init(id: "cr-1", title: "İstehlak krediti", subtitle: "Qalıq borc", amount: "3 200,00 ₼"),
            .init(id: "cr-2", title: "Avtomobil krediti", subtitle: "Qalıq borc", amount: "18 500,00 ₼")
        ])
        let homeActions = RBHomeFlowQuickActionsModel(items: [
            .init(id: "a1", title: "Ödəniş et", icon: .custom(.actionPayment), onTap: {}),
            .init(id: "a2", title: "Qrafik", icon: .system("calendar"), onTap: {}),
            .init(id: "a3", title: "Tarix", icon: .system("clock"), onTap: {}),
            .init(id: "a4", title: "Əlavə", icon: .system("plus.circle"), onTap: {})
        ])
        let schedule = RBHomeFlowInfoListModel(title: "Ödəniş qrafiki", items: [
            .init(id: "s1", title: "Növbəti ödəniş", subtitle: "01 aprel 2026", value: "320,00 ₼"),
            .init(id: "s2", title: "Əsas borc", value: "3 200,00 ₼"),
            .init(id: "s3", title: "Faiz borcu", value: "48,00 ₼"),
            .init(id: "s4", title: "Cəmi ödəniləcək", value: "368,00 ₼"),
            .init(id: "s5", title: "Son ödəniş tarixi", subtitle: "Nisan 2028", value: nil)
        ])
        let panel = RBHomeFlowPanelModel(title: "Ödəniş tarixi", items: [
            .init(id: "p1", date: "01 mart 2026", title: "Aylıq ödəniş", subtitle: "İstehlak krediti", amount: "-368,00 ₼", isCredit: false),
            .init(id: "p2", date: "01 fevral 2026", title: "Aylıq ödəniş", subtitle: "İstehlak krediti", amount: "-368,00 ₼", isCredit: false),
            .init(id: "p3", date: "01 yanvar 2026", title: "Aylıq ödəniş", subtitle: "İstehlak krediti", amount: "-368,00 ₼", isCredit: false),
            .init(id: "p4", date: "01 dekabr 2025", title: "Aylıq ödəniş", subtitle: "İstehlak krediti", amount: "-368,00 ₼", isCredit: false)
        ])

        let detailSchedule = RBHomeFlowInfoListModel(title: "Kredit şərtləri", items: [
            .init(id: "d1", title: "Kredit məbləği", value: "5 000,00 ₼"),
            .init(id: "d2", title: "Faiz dərəcəsi", value: "18% illik"),
            .init(id: "d3", title: "Müddət", value: "24 ay"),
            .init(id: "d4", title: "Aylıq ödəniş", value: "368,00 ₼"),
            .init(id: "d5", title: "Cəmi ödəniləcək", value: "8 832,00 ₼"),
            .init(id: "d6", title: "Verilmə tarixi", value: "01.04.2024"),
            .init(id: "d7", title: "Bitmə tarixi", value: "01.04.2026")
        ])
        let detailActionItems = RBHomeFlowDetailActionsModel(title: "Kredit xidmətləri", items: [
            .init(id: "s1", title: "Erkən ödəmə", description: "Krediti müddətdən əvvəl ödə", systemImage: "checkmark.circle.fill", onTap: {}),
            .init(id: "s2", title: "Ödəniş qrafiki", description: "Tam ödəniş cədvəlini gör", systemImage: "calendar", onTap: {}),
            .init(id: "s3", title: "Yenidən maliyyələşdirmə", description: "Daha əlverişli şərtlərə keç", systemImage: "arrow.2.circlepath", onTap: {}),
            .init(id: "s4", title: "Müqavilə", description: "Kredit müqaviləsini yüklə", systemImage: "doc.text.fill", onTap: {})
        ])

        return .init(
            home: .credit(.init(
                cardsState: .loaded(carousel),
                actionsState: .loaded(homeActions),
                scheduleState: .loaded(schedule),
                panelState: .loaded(panel)
            )),
            detail: .credit(.init(
                title: "İstehlak krediti",
                cardsState: .loaded(carousel),
                scheduleState: .loaded(detailSchedule),
                actionsState: .loaded(detailActionItems),
                panelState: .loaded(panel)
            ))
        )
    }
}

// MARK: - Deposit Placeholder

private extension RBHomeFlowSegmentPayload {
    static var depositPlaceholder: RBHomeFlowSegmentPayload {
        let carousel = RBHomeFlowCarouselModel(items: [
            .init(id: "dep-1", title: "\"Gəlirli\" əmanət", subtitle: "AZN • 12 ay", amount: "10 000,00 ₼"),
            .init(id: "dep-2", title: "\"Optimal\" əmanət", subtitle: "USD • 6 ay", amount: "2 000,00 $")
        ])
        let homeActions = RBHomeFlowQuickActionsModel(items: [
            .init(id: "a1", title: "Yenilə", icon: .system("arrow.clockwise.circle.fill"), onTap: {}),
            .init(id: "a2", title: "Tarix", icon: .system("clock"), onTap: {}),
            .init(id: "a3", title: "Hesabla", icon: .system("percent"), onTap: {}),
            .init(id: "a4", title: "Yeni", icon: .system("plus.circle"), onTap: {})
        ])
        let conditions = RBHomeFlowInfoListModel(title: "Şərtlər", items: [
            .init(id: "c1", title: "Faiz dərəcəsi", value: "10% illik"),
            .init(id: "c2", title: "Müddət", value: "12 ay"),
            .init(id: "c3", title: "Açılış tarixi", value: "15.03.2025"),
            .init(id: "c4", title: "Bitmə tarixi", value: "15.03.2026"),
            .init(id: "c5", title: "Aylıq gəlir", value: "83,33 ₼")
        ])
        let panel = RBHomeFlowPanelModel(title: "Gəlir tarixi", items: [
            .init(id: "p1", date: "01 mart 2026", title: "Faiz gəliri", subtitle: "\"Gəlirli\" əmanət", amount: "+83,33 ₼", isCredit: true),
            .init(id: "p2", date: "01 fevral 2026", title: "Faiz gəliri", subtitle: "\"Gəlirli\" əmanət", amount: "+83,33 ₼", isCredit: true),
            .init(id: "p3", date: "01 yanvar 2026", title: "Faiz gəliri", subtitle: "\"Gəlirli\" əmanət", amount: "+83,33 ₼", isCredit: true),
            .init(id: "p4", date: "01 dekabr 2025", title: "Faiz gəliri", subtitle: "\"Gəlirli\" əmanət", amount: "+83,33 ₼", isCredit: true)
        ])

        let detailConditions = RBHomeFlowInfoListModel(title: "Əmanət şərtləri", items: [
            .init(id: "d1", title: "Məbləğ", value: "10 000,00 ₼"),
            .init(id: "d2", title: "Valyuta", value: "AZN (₼)"),
            .init(id: "d3", title: "Faiz dərəcəsi", value: "10% illik"),
            .init(id: "d4", title: "Müddət", value: "12 ay"),
            .init(id: "d5", title: "Cəmi gəlir", value: "1 000,00 ₼"),
            .init(id: "d6", title: "Açılış tarixi", value: "15.03.2025"),
            .init(id: "d7", title: "Bitmə tarixi", value: "15.03.2026"),
            .init(id: "d8", title: "Avtoyeniləmə", value: "Aktiv")
        ])
        let detailActionItems = RBHomeFlowDetailActionsModel(title: "Əmanət xidmətləri", items: [
            .init(id: "s1", title: "Erkən bağlama", description: "Əmanəti müddətdən əvvəl bağla", systemImage: "xmark.circle.fill", onTap: {}),
            .init(id: "s2", title: "Faiz hesablaması", description: "Gəlir kalkulyatoru", systemImage: "percent", onTap: {}),
            .init(id: "s3", title: "Yeniləmə şərtləri", description: "Avtoyeniləmə parametrlərini dəyiş", systemImage: "arrow.clockwise.circle.fill", onTap: {}),
            .init(id: "s4", title: "Müqavilə", description: "Əmanət müqaviləsini yüklə", systemImage: "doc.text.fill", onTap: {})
        ])

        return .init(
            home: .deposit(.init(
                cardsState: .loaded(carousel),
                actionsState: .loaded(homeActions),
                conditionsState: .loaded(conditions),
                panelState: .loaded(panel)
            )),
            detail: .deposit(.init(
                title: "\"Gəlirli\" əmanət",
                cardsState: .loaded(carousel),
                conditionsState: .loaded(detailConditions),
                actionsState: .loaded(detailActionItems),
                panelState: .loaded(panel)
            ))
        )
    }
}
