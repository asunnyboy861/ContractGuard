import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Contract> { !$0.isArchived },
           sort: \Contract.endDate) private var contracts: [Contract]
    @State private var viewModel = DashboardViewModel()
    @State private var purchaseManager = PurchaseManager()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    urgencySummary
                    SearchBar(text: $viewModel.searchText)
                    urgencyFilter
                    contractList
                }
                .padding()
            }
            .navigationTitle("ContractGuard")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if !purchaseManager.isPremium && contracts.count >= 3 {
                            viewModel.showingPaywall = true
                        } else {
                            viewModel.showingAddContract = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddContract) {
                ContractFormView()
            }
            .sheet(isPresented: $viewModel.showingPaywall) {
                PaywallView(purchaseManager: purchaseManager)
            }
        }
    }

    private var urgencySummary: some View {
        let counts = viewModel.countByUrgency(contracts: contracts)
        return HStack(spacing: 12) {
            UrgencyStatView(level: .critical, count: counts[.critical] ?? 0)
            UrgencyStatView(level: .warning, count: counts[.warning] ?? 0)
            UrgencyStatView(level: .caution, count: counts[.caution] ?? 0)
            UrgencyStatView(level: .safe, count: counts[.safe] ?? 0)
        }
    }

    private var urgencyFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(label: "All", isSelected: viewModel.selectedUrgency == nil) {
                    viewModel.selectedUrgency = nil
                }
                ForEach([UrgencyLevel.critical, .warning, .caution, .safe], id: \.self) { level in
                    FilterChip(label: level.label, isSelected: viewModel.selectedUrgency == level) {
                        viewModel.selectedUrgency = level
                    }
                }
            }
        }
    }

    private var contractList: some View {
        let filtered = viewModel.loadContracts(contracts: contracts)
        return LazyVStack(spacing: 12) {
            if filtered.isEmpty {
                ContentUnavailableView(
                    "No Contracts",
                    systemImage: "doc.text",
                    description: Text("Add your first contract to start tracking")
                )
            } else {
                ForEach(filtered) { contract in
                    NavigationLink(value: contract) {
                        ContractCardView(contract: contract)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct UrgencyStatView: View {
    let level: UrgencyLevel
    let count: Int

    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(level.label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var color: Color {
        switch level {
        case .expired: return .urgencyExpired
        case .critical: return .urgencyCritical
        case .warning: return .urgencyWarning
        case .caution: return .urgencyCaution
        case .safe: return .urgencySafe
        }
    }
}

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor : Color(.tertiarySystemFill))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
