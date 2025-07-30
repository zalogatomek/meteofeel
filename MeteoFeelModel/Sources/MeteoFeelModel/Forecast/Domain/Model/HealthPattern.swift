import Foundation

public struct HealthPattern: Codable, Equatable, Sendable {

    // MARK: - Properties

    public let healthIssue: HealthIssue
    public let condition: HealthPatternCondition
    public let value: WeatherMeasurement
    public let risk: HealthRisk

    // MARK: - Lifecycle

    public init(
        healthIssue: HealthIssue,
        condition: HealthPatternCondition,
        value: WeatherMeasurement,
        risk: HealthRisk
    ) {
        self.healthIssue = healthIssue
        self.condition = condition
        self.value = value
        self.risk = risk
    }
} 