import SwiftUI
import SwiftData

struct ContractDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var contract: Contract
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var notificationService = NotificationService()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                urgencyHeader
                countdownSection
                detailsSection
                if !contract.aiExtractedClauses.isEmpty {
                    clausesSection
                }
                remindersSection
                actionsSection
            }
            .padding()
        }
        .navigationTitle(contract.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingEditSheet = true
                } label: {
                    Image(systemName: "pencil")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            ContractFormView(contract: contract)
        }
        .alert("Delete Contract?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                contract.isArchived = true
                notificationService.removeReminders(for: contract)
                try? modelContext.save()
            }
        }
    }

    private var urgencyHeader: some View {
        HStack {
            UrgencyBadge(level: contract.urgencyLevel)
            Spacer()
            Text(contract.contractType.rawValue)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var countdownSection: some View {
        HStack(spacing: 20) {
            CountdownView(days: contract.daysUntilExpiry, label: "expiry")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.tertiarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            CountdownView(days: contract.daysUntilNoticeDeadline, label: "notice")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.tertiarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Contract Details")
            DetailRow(label: "Vendor", value: contract.vendorName)
            DetailRow(label: "Start Date", value: contract.startDate.formattedMedium)
            DetailRow(label: "End Date", value: contract.endDate.formattedMedium)
            DetailRow(label: "Notice Period", value: "\(contract.noticePeriodDays) days")
            DetailRow(label: "Notice Deadline", value: contract.noticeDeadlineDate.formattedMedium)
            DetailRow(label: "Auto-Renews", value: contract.autoRenews ? "Yes" : "No")
            if contract.autoRenews {
                DetailRow(label: "Renewal Term", value: "\(contract.renewalTermMonths) months")
            }
            if contract.contractValue > 0 {
                DetailRow(label: "Value", value: contract.formattedValue)
            }
            if !contract.ownerName.isEmpty {
                DetailRow(label: "Owner", value: contract.ownerName)
            }
            if !contract.notes.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Notes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(contract.notes)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var clausesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "AI Extracted Clauses")
            ForEach(contract.aiExtractedClauses, id: \.id) { clause in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(clause.clauseType.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Spacer()
                        Text("\(Int(clause.confidence * 100))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Text(clause.extractedValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var remindersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Reminders")
            ForEach(contract.reminders, id: \.id) { reminder in
                HStack {
                    Image(systemName: reminder.reminderType == .push ? "bell" : "envelope")
                        .foregroundColor(.accentColor)
                    Text("\(reminder.daysBefore) days before")
                        .font(.subheadline)
                    Spacer()
                    Text(reminder.isSent ? "Sent" : "Pending")
                        .font(.caption)
                        .foregroundColor(reminder.isSent ? .green : .orange)
                }
            }
            if contract.reminders.isEmpty {
                Text("No reminders set")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var actionsSection: some View {
        VStack(spacing: 12) {
            Button {
                notificationService.scheduleReminders(for: contract)
            } label: {
                Label("Set Reminders", systemImage: "bell.badge")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Button(role: .destructive) {
                showingDeleteAlert = true
            } label: {
                Label("Archive Contract", systemImage: "archivebox")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
    }
}

struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}
