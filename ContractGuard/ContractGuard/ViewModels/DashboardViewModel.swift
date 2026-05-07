import SwiftData
import Foundation

@Observable
final class DashboardViewModel {
    var searchText = ""
    var selectedUrgency: UrgencyLevel?
    var selectedType: ContractType?
    var showingAddContract = false
    var showingPaywall = false

    var filteredContracts: [Contract] = []

    func loadContracts(contracts: [Contract]) -> [Contract] {
        var result = contracts.filter { !$0.isArchived }

        if !searchText.isEmpty {
            let query = searchText.lowercased()
            result = result.filter {
                $0.title.lowercased().contains(query) ||
                $0.vendorName.lowercased().contains(query) ||
                $0.notes.lowercased().contains(query)
            }
        }

        if let urgency = selectedUrgency {
            result = result.filter { $0.urgencyLevel == urgency }
        }

        if let type = selectedType {
            result = result.filter { $0.contractType == type }
        }

        return result.sorted { $0.daysUntilNoticeDeadline < $1.daysUntilNoticeDeadline }
    }

    var urgencyCounts: [UrgencyLevel: Int] {
        var counts: [UrgencyLevel: Int] = [:]
        for level in [UrgencyLevel.expired, .critical, .warning, .caution, .safe] {
            counts[level] = 0
        }
        return counts
    }

    func countByUrgency(contracts: [Contract]) -> [UrgencyLevel: Int] {
        var counts: [UrgencyLevel: Int] = [:]
        for level in [UrgencyLevel.expired, .critical, .warning, .caution, .safe] {
            counts[level] = contracts.filter { !$0.isArchived && $0.urgencyLevel == level }.count
        }
        return counts
    }
}
