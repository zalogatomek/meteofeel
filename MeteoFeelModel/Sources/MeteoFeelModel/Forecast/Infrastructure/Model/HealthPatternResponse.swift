import Foundation

struct HealthPatternResponse: Codable {
    let patterns: [HealthPattern]?
    
    struct HealthPattern: Codable {
        let healthIssue: HealthIssueResponse?
        let parameter: WeatherParameterResponse?
        let condition: HealthPatternConditionResponse?
        let thresholds: RiskThresholds?
    }
    
    struct RiskThresholds: Codable {
        let high: Double?
        let medium: Double?
    }
}
