import Foundation

struct AIExtractionResult: Codable {
    let contractTitle: String?
    let vendorName: String?
    let startDate: String?
    let endDate: String?
    let noticePeriodDays: Int?
    let autoRenews: Bool?
    let renewalTermMonths: Int?
    let contractValue: Double?
    let currency: String?
    let contractType: String?
    let clauses: [AIClause]?
    let keyRisks: [String]?
    let summary: String?

    enum CodingKeys: String, CodingKey {
        case contractTitle = "contract_title"
        case vendorName = "vendor_name"
        case startDate = "start_date"
        case endDate = "end_date"
        case noticePeriodDays = "notice_period_days"
        case autoRenews = "auto_renews"
        case renewalTermMonths = "renewal_term_months"
        case contractValue = "contract_value"
        case currency
        case contractType = "contract_type"
        case clauses
        case keyRisks = "key_risks"
        case summary
    }
}

struct AIClause: Codable {
    let type: String
    let originalText: String
    let extractedValue: String
    let confidence: Double
    let pageNumber: Int

    enum CodingKeys: String, CodingKey {
        case type
        case originalText = "original_text"
        case extractedValue = "extracted_value"
        case confidence
        case pageNumber = "page_number"
    }
}

@Observable
final class AIExtractionService {
    var isExtracting = false
    var extractionError: String?

    private let baseURL = "https://api.anthropic.com/v1/messages"

    func extractContractInfo(from text: String, apiKey: String) async throws -> AIExtractionResult {
        isExtracting = true
        defer { isExtracting = false }
        extractionError = nil

        let prompt = """
        You are a contract analysis expert. Extract the following information from this contract text.
        Return ONLY valid JSON with these fields:
        {
            "contract_title": "string or null",
            "vendor_name": "string or null",
            "start_date": "YYYY-MM-DD or null",
            "end_date": "YYYY-MM-DD or null",
            "notice_period_days": number or null,
            "auto_renews": boolean or null,
            "renewal_term_months": number or null,
            "contract_value": number or null,
            "currency": "string or null",
            "contract_type": "SaaS|Lease|Service|Insurance|Vendor|Employment|NDA|License|Subscription|Maintenance|Other",
            "clauses": [
                {
                    "type": "Renewal Date|Notice Period|Auto-Renewal|Termination|Payment Terms|Price Escalation|Penalty",
                    "original_text": "exact quote from contract",
                    "extracted_value": "simplified value",
                    "confidence": 0.0-1.0,
                    "page_number": number
                }
            ],
            "key_risks": ["list of potential risks"],
            "summary": "2-3 sentence summary"
        }

        If a field cannot be determined, use null. Be conservative with confidence scores.

        Contract text:
        \(text)
        """

        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")

        let body: [String: Any] = [
            "model": "claude-sonnet-4-20250514",
            "max_tokens": 4096,
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)

        struct ClaudeResponse: Codable {
            let content: [ContentBlock]
            struct ContentBlock: Codable {
                let type: String
                let text: String
            }
        }

        let response = try JSONDecoder().decode(ClaudeResponse.self, from: data)

        guard let contentBlock = response.content.first,
              contentBlock.type == "text" else {
            extractionError = "Invalid AI response"
            throw NSError(domain: "AIExtraction", code: 1)
        }

        let jsonString = contentBlock.text
            .replacingOccurrences(of: "```json\n", with: "")
            .replacingOccurrences(of: "\n```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let jsonData = jsonString.data(using: .utf8)!
        let result = try JSONDecoder().decode(AIExtractionResult.self, from: jsonData)
        return result
    }
}
