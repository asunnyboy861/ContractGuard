import SwiftData
import Foundation

@Model
final class ContractReminder {
    var id: UUID = UUID()
    var reminderDate: Date = Date()
    var daysBefore: Int = 7
    var isSent: Bool = false
    var sentDate: Date?
    var reminderTypeRaw: String = "push"

    var reminderType: ReminderType {
        get { ReminderType(rawValue: reminderTypeRaw) ?? .push }
        set { reminderTypeRaw = newValue.rawValue }
    }
    var contract: Contract?

    init(daysBefore: Int, reminderType: ReminderType = .push) {
        self.id = UUID()
        self.daysBefore = daysBefore
        self.reminderType = reminderType
        self.isSent = false
        self.sentDate = nil
        self.reminderDate = Date()
    }
}
