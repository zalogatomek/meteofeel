import Foundation

struct HealthPatternResponse: Codable {
    let patterns: [HealthPattern]?
    
    struct HealthPattern: Codable {
        let healthIssue: HealthIssueResponse?
        let parameter: WeatherParameterResponse?
        let condition: HealthPatternConditionResponse?
        let value: Double?
        let weatherCondition: WeatherConditionResponse?
        let risk: HealthRiskResponse?
    }
}
