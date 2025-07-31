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

extension HealthPatternResponse {
    
    // MARK: - Stubs
    
    static func createStub(
        patterns: [HealthPattern]? = [
            .createStub()
        ]
    ) -> HealthPatternResponse {
        HealthPatternResponse(patterns: patterns)
    }
}

extension HealthPatternResponse.HealthPattern {
    
    // MARK: - Stubs
    
    static func createStub(
        healthIssue: HealthIssueResponse? = .headache,
        parameter: WeatherParameterResponse? = .temperature,
        condition: HealthPatternConditionResponse? = .above,
        thresholds: HealthPatternResponse.RiskThresholds? = .createStub()
    ) -> HealthPatternResponse.HealthPattern {
        HealthPatternResponse.HealthPattern(
            healthIssue: healthIssue,
            parameter: parameter,
            condition: condition,
            thresholds: thresholds
        )
    }
}

extension HealthPatternResponse.RiskThresholds {
    
    // MARK: - Stubs
    
    static func createStub(
        high: Double? = 30.0,
        medium: Double? = 25.0
    ) -> HealthPatternResponse.RiskThresholds {
        HealthPatternResponse.RiskThresholds(high: high, medium: medium)
    }
}
