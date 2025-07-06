import Foundation

public struct HealthPattern: Codable, Equatable, Sendable {
    public let healthIssue: HealthIssue
    public let parameter: WeatherParameter
    public let condition: HealthPatternCondition
    public let value: WeatherMeasurementValue
    public let risk: HealthRisk
    
    public init(
        healthIssue: HealthIssue,
        parameter: WeatherParameter,
        condition: HealthPatternCondition,
        value: WeatherMeasurementValue,
        risk: HealthRisk
    ) {
        self.healthIssue = healthIssue
        self.parameter = parameter
        self.condition = condition
        self.value = value
        self.risk = risk
    }
} 