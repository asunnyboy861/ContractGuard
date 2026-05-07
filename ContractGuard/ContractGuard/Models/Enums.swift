import SwiftData
import Foundation

enum ContractType: String, Codable, CaseIterable {
    case saas = "SaaS"
    case lease = "Lease"
    case service = "Service"
    case insurance = "Insurance"
    case vendor = "Vendor"
    case employment = "Employment"
    case nda = "NDA"
    case license = "License"
    case subscription = "Subscription"
    case maintenance = "Maintenance"
    case other = "Other"
}

enum UrgencyLevel: String, Codable {
    case expired = "expired"
    case critical = "critical"
    case warning = "warning"
    case caution = "caution"
    case safe = "safe"

    var colorName: String {
        switch self {
        case .expired: return "UrgencyExpired"
        case .critical: return "UrgencyCritical"
        case .warning: return "UrgencyWarning"
        case .caution: return "UrgencyCaution"
        case .safe: return "UrgencySafe"
        }
    }

    var label: String {
        switch self {
        case .expired: return "Expired"
        case .critical: return "Critical"
        case .warning: return "Warning"
        case .caution: return "Caution"
        case .safe: return "Safe"
        }
    }

    var systemImage: String {
        switch self {
        case .expired: return "xmark.circle.fill"
        case .critical: return "exclamationmark.triangle.fill"
        case .warning: return "exclamationmark.circle.fill"
        case .caution: return "info.circle.fill"
        case .safe: return "checkmark.circle.fill"
        }
    }
}

enum ReminderType: String, Codable {
    case push = "push"
    case email = "email"
    case both = "both"
}

enum ClauseType: String, Codable, CaseIterable {
    case renewalDate = "Renewal Date"
    case noticePeriod = "Notice Period"
    case autoRenewal = "Auto-Renewal"
    case terminationClause = "Termination"
    case paymentTerms = "Payment Terms"
    case escalationClause = "Price Escalation"
    case penaltyClause = "Penalty"
}
