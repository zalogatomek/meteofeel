import Foundation
import MeteoFeelModel

struct HealthAlertStringFactory {
    
    // MARK: - Create
    
    static func create(_ alert: HealthAlert) -> String {
        let riskText = alert.pattern.risk.displayName
        let healthIssueText = alert.pattern.healthIssue.displayName.lowercased()
        let conditionText = alert.pattern.condition.displayText
        let parameterText = alert.pattern.value.parameter.displayName.lowercased()
        let conditionParameterText = [conditionText, parameterText].compactMap { $0 }.joined(separator: " ")
        
        return "\(riskText) risk of \(healthIssueText) due to \(conditionParameterText)"
    }
}