import SwiftData
import Foundation

@Model
final class Contract {
    var id: UUID = UUID()
    var title: String = ""
    var vendorName: String = ""
    var contractTypeRaw: String = "Other"

    var contractType: ContractType {
        get { ContractType(rawValue: contractTypeRaw) ?? .other }
        set { contractTypeRaw = newValue.rawValue }
    }
    var startDate: Date = Date()
    var endDate: Date = Date().addingTimeInterval(365 * 24 * 3600)
    var noticePeriodDays: Int = 30
    var autoRenews: Bool = false
    var renewalTermMonths: Int = 12
    var contractValue: Double = 0
    var currency: String = "USD"
    var notes: String = ""
    var tags: [String] = []
    var documentPath: String?
    var documentThumbnailPath: String?
    var ownerName: String = ""
    var ownerEmail: String = ""
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    var isArchived: Bool = false

    @Relationship(deleteRule: .cascade, inverse: \ContractReminder.contract)
    var reminders: [ContractReminder] = []

    @Relationship(deleteRule: .cascade, inverse: \ExtractedClause.contract)
    var aiExtractedClauses: [ExtractedClause] = []

    var noticeDeadlineDate: Date {
        Calendar.current.date(byAdding: .day, value: -noticePeriodDays, to: endDate) ?? endDate
    }

    var daysUntilExpiry: Int {
        Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: endDate)).day ?? 0
    }

    var daysUntilNoticeDeadline: Int {
        Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: noticeDeadlineDate)).day ?? 0
    }

    var urgencyLevel: UrgencyLevel {
        if daysUntilNoticeDeadline < 0 { return .expired }
        if daysUntilNoticeDeadline <= 7 { return .critical }
        if daysUntilNoticeDeadline <= 30 { return .warning }
        if daysUntilNoticeDeadline <= 60 { return .caution }
        return .safe
    }

    var formattedValue: String {
        if contractValue == 0 { return "—" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: NSNumber(value: contractValue)) ?? "—"
    }

    init(title: String, vendorName: String, contractType: ContractType,
         startDate: Date, endDate: Date, noticePeriodDays: Int = 30,
         autoRenews: Bool = false, renewalTermMonths: Int = 12) {
        self.id = UUID()
        self.title = title
        self.vendorName = vendorName
        self.contractType = contractType
        self.startDate = startDate
        self.endDate = endDate
        self.noticePeriodDays = noticePeriodDays
        self.autoRenews = autoRenews
        self.renewalTermMonths = renewalTermMonths
    }
}
