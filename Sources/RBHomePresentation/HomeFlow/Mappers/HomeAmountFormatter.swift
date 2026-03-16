import Foundation

enum HomeAmountFormatter {
    static func format(_ amount: Double, currency: String) -> String {
        let symbol: String
        switch currency.uppercased() {
        case "AZN": symbol = "₼"
        case "USD": symbol = "$"
        case "EUR": symbol = "€"
        case "RUB": symbol = "₽"
        case "GBP": symbol = "£"
        default:    symbol = currency
        }
        let formatted = formatter.string(from: NSNumber(value: amount)) ?? "0,00"
        return "\(formatted) \(symbol)"
    }

    private static let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        f.groupingSeparator = " "
        f.decimalSeparator = ","
        return f
    }()

    static func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Bu gün"
        } else if calendar.isDateInYesterday(date) {
            return "Dünən"
        } else {
            return dateFormatter.string(from: date)
        }
    }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "az_AZ")
        f.dateFormat = "d MMMM"
        return f
    }()
}
