import SwiftData
import Foundation

@Model
final class ExtractedClause {
    var id: UUID = UUID()
    var clauseTypeRaw: String = "Auto-Renewal"

    var clauseType: ClauseType {
        get { ClauseType(rawValue: clauseTypeRaw) ?? .autoRenewal }
        set { clauseTypeRaw = newValue.rawValue }
    }
    var originalText: String = ""
    var extractedValue: String = ""
    var confidence: Double = 0
    var pageNumber: Int = 0
    var contract: Contract?

    init(clauseType: ClauseType, originalText: String, extractedValue: String,
         confidence: Double, pageNumber: Int) {
        self.id = UUID()
        self.clauseType = clauseType
        self.originalText = originalText
        self.extractedValue = extractedValue
        self.confidence = confidence
        self.pageNumber = pageNumber
    }
}
