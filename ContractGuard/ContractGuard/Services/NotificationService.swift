import UserNotifications
import Foundation

@Observable
final class NotificationService {
    var isNotificationAuthorized = false

    init() {
        checkAuthorization()
    }

    func checkAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isNotificationAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }

    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            isNotificationAuthorized = granted
            return granted
        } catch {
            return false
        }
    }

    func scheduleReminders(for contract: Contract) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        let noticeDays = [90, 60, 30, 7, 1]
        for daysBefore in noticeDays {
            let triggerDate = contract.endDate.adding(days: -daysBefore)
            guard triggerDate > Date() else { continue }

            let content = UNMutableNotificationContent()
            content.title = "ContractGuard Alert"
            content.body = "\(contract.title) - \(daysBefore) days until expiration"
            content.sound = .default
            content.userInfo = ["contractId": contract.id.uuidString]

            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

            let request = UNNotificationRequest(identifier: "\(contract.id.uuidString)-\(daysBefore)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }

        if contract.autoRenews {
            let noticeTriggerDate = contract.noticeDeadlineDate.adding(days: -7)
            guard noticeTriggerDate > Date() else { return }

            let content = UNMutableNotificationContent()
            content.title = "ContractGuard - Notice Deadline"
            content.body = "\(contract.title) - 7 days until notice deadline! Cancel auto-renewal now."
            content.sound = .defaultCritical

            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: noticeTriggerDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

            let request = UNNotificationRequest(identifier: "\(contract.id.uuidString)-notice", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }

    func removeReminders(for contract: Contract) {
        let noticeDays = [90, 60, 30, 7, 1]
        var identifiers = noticeDays.map { "\(contract.id.uuidString)-\($0)" }
        identifiers.append("\(contract.id.uuidString)-notice")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
