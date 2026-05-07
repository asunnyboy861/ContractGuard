import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    let purchaseManager: PurchaseManager
    @State private var selectedPlan: PlanType = .yearly

    enum PlanType {
        case monthly
        case yearly
        case lifetime
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    featuresSection
                    planSelector
                    subscribeButton
                    restoreButton
                    legalLinks
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Upgrade to Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "shield.checkered")
                .font(.system(size: 48))
                .foregroundColor(.accentColor)
            Text("ContractGuard Premium")
                .font(.title2)
                .fontWeight(.bold)
            Text("Never miss a contract deadline again")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }

    private var featuresSection: some View {
        VStack(spacing: 12) {
            FeatureRow(icon: "infinity", title: "Unlimited Contracts", description: "Track as many contracts as you need")
            FeatureRow(icon: "brain", title: "AI Extraction", description: "Auto-extract clauses from uploaded documents")
            FeatureRow(icon: "doc.text.viewfinder", title: "Document Scanning", description: "Scan and digitize paper contracts")
            FeatureRow(icon: "bell.badge", title: "Multi-Timepoint Alerts", description: "90/60/30/7/1 day reminders")
            FeatureRow(icon: "cloud", title: "iCloud Sync", description: "Sync across all your Apple devices")
            FeatureRow(icon: "calendar", title: "Calendar Integration", description: "Sync deadlines to Apple Calendar")
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var planSelector: some View {
        VStack(spacing: 12) {
            PlanCard(title: "Monthly", price: "$4.99/mo", isSelected: selectedPlan == .monthly) {
                selectedPlan = .monthly
            }
            PlanCard(title: "Yearly", price: "$29.99/yr", subtitle: "Save 50%", isSelected: selectedPlan == .yearly) {
                selectedPlan = .yearly
            }
            PlanCard(title: "Lifetime", price: "$79.99 once", subtitle: "Best value", isSelected: selectedPlan == .lifetime) {
                selectedPlan = .lifetime
            }
        }
    }

    private var subscribeButton: some View {
        Button {
            Task {
                let product: Product?
                switch selectedPlan {
                case .monthly: product = purchaseManager.monthlyProduct
                case .yearly: product = purchaseManager.yearlyProduct
                case .lifetime: product = purchaseManager.lifetimeProduct
                }
                if let product {
                    let success = await purchaseManager.purchase(product)
                    if success {
                        dismiss()
                    }
                }
            }
        } label: {
            Text(purchaseManager.isLoading ? "Processing..." : "Subscribe Now")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(purchaseManager.isLoading)
    }

    private var restoreButton: some View {
        Button {
            Task {
                await purchaseManager.restorePurchases()
            }
        } label: {
            Text("Restore Purchases")
                .font(.subheadline)
                .foregroundColor(.accentColor)
        }
    }

    private var legalLinks: some View {
        VStack(spacing: 4) {
            Text("7-day free trial, then auto-renews. Cancel anytime.")
                .font(.caption2)
                .foregroundColor(.secondary)
            HStack(spacing: 4) {
                Link("Privacy Policy", destination: URL(string: "https://asunnyboy861.github.io/ContractGuard/privacy.html")!)
                Text("|")
                Link("Terms of Use", destination: URL(string: "https://asunnyboy861.github.io/ContractGuard/terms.html")!)
            }
            .font(.caption2)
        }
        .padding(.bottom, 20)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentColor)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct PlanCard: View {
    let title: String
    let price: String
    var subtitle: String? = nil
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text(price)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                if let subtitle {
                    Text(subtitle)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.accentColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.accentColor.opacity(0.1))
                        .clipShape(Capsule())
                }
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .accentColor : .secondary)
            }
            .padding()
            .background(isSelected ? Color.accentColor.opacity(0.05) : Color(.tertiarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}
