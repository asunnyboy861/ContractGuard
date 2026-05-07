import SwiftUI
import SwiftData

struct CalendarView: View {
    @Query(filter: #Predicate<Contract> { !$0.isArchived }) private var contracts: [Contract]
    @State private var selectedDate = Date()

    private var contractsExpiringInMonth: [Contract] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!

        return contracts.filter { contract in
            contract.endDate >= startOfMonth && contract.endDate < endOfMonth
        }
    }

    private var contractsByNoticeDeadline: [Contract] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!

        return contracts.filter { contract in
            contract.noticeDeadlineDate >= startOfMonth && contract.noticeDeadlineDate < endOfMonth
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Expiring This Month") {
                    if contractsExpiringInMonth.isEmpty {
                        Text("No contracts expiring this month")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(contractsExpiringInMonth) { contract in
                            NavigationLink(value: contract) {
                                ContractRow(contract: contract)
                            }
                        }
                    }
                }

                Section("Notice Deadlines This Month") {
                    if contractsByNoticeDeadline.isEmpty {
                        Text("No notice deadlines this month")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(contractsByNoticeDeadline) { contract in
                            NavigationLink(value: contract) {
                                ContractRow(contract: contract)
                            }
                        }
                    }
                }

                Section("All Upcoming") {
                    let upcoming = contracts
                        .filter { $0.endDate > Date() }
                        .sorted { $0.endDate < $1.endDate }
                    ForEach(upcoming) { contract in
                        NavigationLink(value: contract) {
                            ContractRow(contract: contract)
                        }
                    }
                }
            }
            .navigationTitle("Calendar")
        }
    }
}

struct ContractRow: View {
    let contract: Contract

    var body: some View {
        HStack {
            Circle()
                .fill(colorForUrgency(contract.urgencyLevel))
                .frame(width: 8, height: 8)
            VStack(alignment: .leading) {
                Text(contract.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(contract.vendorName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(contract.endDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                Text("\(contract.daysUntilExpiry)d")
                    .font(.caption2)
                    .foregroundColor(contract.daysUntilExpiry <= 30 ? .orange : .secondary)
            }
        }
    }

    private func colorForUrgency(_ level: UrgencyLevel) -> Color {
        switch level {
        case .expired: return .urgencyExpired
        case .critical: return .urgencyCritical
        case .warning: return .urgencyWarning
        case .caution: return .urgencyCaution
        case .safe: return .urgencySafe
        }
    }
}
