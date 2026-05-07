import SwiftUI

extension Date {
    var formattedShort: String {
        formatted(date: .abbreviated, time: .omitted)
    }

    var formattedMedium: String {
        formatted(date: .long, time: .omitted)
    }

    var relativeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    func adding(days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }

    func adding(months: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: months, to: self) ?? self
    }

    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}

extension Color {
    static let urgencyExpired = Color(red: 142/255, green: 142/255, blue: 147/255)
    static let urgencyCritical = Color(red: 255/255, green: 59/255, blue: 48/255)
    static let urgencyWarning = Color(red: 255/255, green: 149/255, blue: 0/255)
    static let urgencyCaution = Color(red: 255/255, green: 204/255, blue: 0/255)
    static let urgencySafe = Color(red: 52/255, green: 199/255, blue: 89/255)
}
