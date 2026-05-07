import SwiftUI

struct ContractCardView: View {
    let contract: Contract

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(contract.title)
                        .font(.headline)
                        .lineLimit(1)
                    Spacer()
                    UrgencyBadge(level: contract.urgencyLevel)
                }

                HStack {
                    Image(systemName: "building.2")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(contract.vendorName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                HStack(spacing: 16) {
                    Label(contract.endDate.formattedShort, systemImage: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    if contract.autoRenews {
                        Label("Auto-renews", systemImage: "arrow.clockwise")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }

                    if contract.contractValue > 0 {
                        Label(contract.formattedValue, systemImage: "dollarsign.circle")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            CountdownView(days: contract.daysUntilNoticeDeadline, label: "notice")
                .frame(width: 60)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
