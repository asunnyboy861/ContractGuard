import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("useCloudKit") private var useCloudKit = false
    @AppStorage("defaultNoticeDays") private var defaultNoticeDays = 30
    @AppStorage("enableNotifications") private var enableNotifications = true
    @State private var purchaseManager = PurchaseManager()
    @State private var showingContactSupport = false

    private let supportURL = "https://asunnyboy861.github.io/ContractGuard/support.html"
    private let privacyURL = "https://asunnyboy861.github.io/ContractGuard/privacy.html"
    private let termsURL = "https://asunnyboy861.github.io/ContractGuard/terms.html"

    var body: some View {
        NavigationStack {
            Form {
                Section("Subscription") {
                    if purchaseManager.isPremium {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.yellow)
                            Text("Premium Active")
                                .fontWeight(.medium)
                            Spacer()
                            Text("Active")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    } else {
                        Button {
                        } label: {
                            HStack {
                                Image(systemName: "crown")
                                Text("Upgrade to Premium")
                            }
                        }
                    }
                    Button {
                        Task {
                            await purchaseManager.restorePurchases()
                        }
                    } label: {
                        Text("Restore Purchases")
                    }
                }

                Section("Notifications") {
                    Toggle("Enable Notifications", isOn: $enableNotifications)
                    Stepper("Default Notice Period: \(defaultNoticeDays) days", value: $defaultNoticeDays, in: 7...365)
                }

                Section("Sync") {
                    Toggle("iCloud Sync", isOn: $useCloudKit)
                    Text("Sync your contracts across all Apple devices")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Section("Support") {
                    Button {
                        showingContactSupport = true
                    } label: {
                        Label("Contact Support", systemImage: "envelope")
                    }
                    Link(destination: URL(string: supportURL)!) {
                        Label("Support Page", systemImage: "questionmark.circle")
                    }
                    Link(destination: URL(string: privacyURL)!) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                    Link(destination: URL(string: termsURL)!) {
                        Label("Terms of Use", systemImage: "doc.text")
                    }
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingContactSupport) {
                ContactSupportView()
            }
        }
    }
}
