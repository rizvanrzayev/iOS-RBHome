import RBHomeDomain

extension HomeCardNetwork {
    /// Returns the design system asset name for the card network logo.
    /// Returns nil for `.none` (no icon to show).
    var assetName: String? {
        switch self {
        case .visa:        return "ds_card_visa"
        case .mastercard:  return "ds_card_master"
        case .maestro:     return "ds_card_master"
        case .discover:    return "ds_card_discover"
        case .none:        return nil
        }
    }
}

extension HomeCard {
    /// Returns the design system background asset name for this card.
    var backgroundAsset: String {
        switch cardType {
        case .stored:
            return "rb.card.bg.stored"
        default:
            switch cardProduct {
            case "GamerCard":
                return isPremium ? "rb.card.bg.plastic.premium" : "rb.card.bg.plastic"
            case "KartmaneJunior":
                return "rb.card.bg.plastic"
            default:
                return isPremium ? "rb.card.bg.plastic.premium" : "rb.card.bg.plastic"
            }
        }
    }
}
