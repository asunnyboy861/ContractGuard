import SwiftUI

struct CountdownView: View {
    let days: Int
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(abs(days).description)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(days < 0 ? .secondary : (days <= 7 ? .urgencyCritical : (days <= 30 ? .urgencyWarning : .primary)))
            Text(days < 0 ? "days overdue" : (days == 1 ? "day" : "days"))
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}
