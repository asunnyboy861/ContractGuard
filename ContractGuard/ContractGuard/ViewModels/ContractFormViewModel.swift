import SwiftData
import Foundation

@Observable
final class ContractFormViewModel {
    var title = ""
    var vendorName = ""
    var contractType: ContractType = .other
    var startDate = Date()
    var endDate = Date().addingTimeInterval(365 * 24 * 3600)
    var noticePeriodDays = 30
    var autoRenews = false
    var renewalTermMonths = 12
    var contractValue: Double = 0
    var currency = "USD"
    var notes = ""
    var ownerName = ""
    var ownerEmail = ""
    var tags: [String] = []

    var isEditing = false
    var editingContract: Contract?

    init() {}

    init(contract: Contract) {
        isEditing = true
        editingContract = contract
        title = contract.title
        vendorName = contract.vendorName
        contractType = contract.contractType
        startDate = contract.startDate
        endDate = contract.endDate
        noticePeriodDays = contract.noticePeriodDays
        autoRenews = contract.autoRenews
        renewalTermMonths = contract.renewalTermMonths
        contractValue = contract.contractValue
        currency = contract.currency
        notes = contract.notes
        ownerName = contract.ownerName
        ownerEmail = contract.ownerEmail
        tags = contract.tags
    }

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !vendorName.trimmingCharacters(in: .whitespaces).isEmpty &&
        endDate > startDate
    }

    func save(using modelContext: ModelContext) {
        if let existing = editingContract {
            existing.title = title
            existing.vendorName = vendorName
            existing.contractType = contractType
            existing.startDate = startDate
            existing.endDate = endDate
            existing.noticePeriodDays = noticePeriodDays
            existing.autoRenews = autoRenews
            existing.renewalTermMonths = renewalTermMonths
            existing.contractValue = contractValue
            existing.currency = currency
            existing.notes = notes
            existing.ownerName = ownerName
            existing.ownerEmail = ownerEmail
            existing.tags = tags
            existing.updatedAt = Date()
        } else {
            let contract = Contract(
                title: title,
                vendorName: vendorName,
                contractType: contractType,
                startDate: startDate,
                endDate: endDate,
                noticePeriodDays: noticePeriodDays,
                autoRenews: autoRenews,
                renewalTermMonths: renewalTermMonths
            )
            contract.contractValue = contractValue
            contract.currency = currency
            contract.notes = notes
            contract.ownerName = ownerName
            contract.ownerEmail = ownerEmail
            contract.tags = tags
            modelContext.insert(contract)
        }

        do {
            try modelContext.save()
        } catch {
            print("Save error: \(error)")
        }
    }
}
