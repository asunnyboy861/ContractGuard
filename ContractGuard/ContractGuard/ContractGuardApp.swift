import SwiftUI
import SwiftData

@main
struct ContractGuardApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Contract.self, ContractReminder.self, ExtractedClause.self])
    }
}
