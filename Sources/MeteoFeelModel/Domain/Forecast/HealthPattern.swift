import Foundation

public struct HealthPattern: Codable, Equatable {
    public let healthIssue: HealthIssue
    public let parameter: WeatherParameter
    public let condition: WeatherCondition
    public let value: WeatherMeasurementValue
    public let risk: HealthRisk
    
    public init(
        healthIssue: HealthIssue,
        parameter: WeatherParameter,
        condition: WeatherCondition,
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