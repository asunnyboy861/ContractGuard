import SwiftUI

struct UrgencyBadge: View {
    let level: UrgencyLevel

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: level.systemImage)
                .font(.caption2)
            Text(level.label)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(backgroundColor.opacity(0.15))
        .foregroundColor(foregroundColor)
        .clipShape(Capsule())
    }

    private var backgroundColor: Color {
        switch level {
        case .expired: return .urgencyExpired
        case .critical: return .urgencyCritical
        case .warning: return .urgencyWarning
        case .caution: return .urgencyCaution
        case .safe: return .urgencySafe
        }
    }

    private var foregroundColor: Color {
        switch level {
        case .expired: return .secondary
        case .critical: return .urgencyCritical
        case .warning: return .urgencyWarning
        case .caution: return .urgencyCaution
        case .safe: return .urgencySafe
        }
    }
}
