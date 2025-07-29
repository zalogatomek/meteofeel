public import Foundation

public struct HealthAlert: Codable, Equatable, Comparable, Sendable {

    // MARK: - Properties

    public let timePeriod: TimePeriod
    public let pattern: HealthPattern
    public let currentValue: WeatherMeasurement

    // MARK: - Lifecycle

    public init(
        timePeriod: TimePeriod,
        pattern: HealthPattern,
        currentValue: WeatherMeasurement
    ) {
        self.timePeriod = timePeriod
        self.pattern = pattern
        self.currentValue = currentValue
    }

    // MARK: - Comparable

    public static func < (lhs: HealthAlert, rhs: HealthAlert) -> Bool {
        if lhs.pattern.healthIssue != rhs.pattern.healthIssue {
            return lhs.pattern.healthIssue < rhs.pattern.healthIssue
        } else if lhs.pattern.risk != rhs.pattern.risk {
            return lhs.pattern.risk > rhs.pattern.risk
        } else {
            return lhs.pattern.value.parameter < rhs.pattern.value.parameter
        }
    }
} 

extension HealthAlert {

    // MARK: - Stubs

    public static func createStub(
        timePeriod: TimePeriod = TimePeriod(date: Date(), timeOfDay: .morning),
        healthIssue: HealthIssue = .headache,
        condition: HealthPatternCondition = .above,
        parameter: WeatherParameter = .temperature,
        value: Double = 25.0,
        risk: HealthRisk = .medium,
        currentValue: WeatherMeasurement? = nil
    ) -> HealthAlert {
        let pattern = HealthPattern(
            healthIssue: healthIssue,
            condition: condition,
            value: WeatherMeasurement(parameter: parameter, value: value),
            risk: risk
        )
        
        let measurement = currentValue ?? WeatherMeasurement(parameter: parameter, value: value)
        
        return HealthAlert(
            timePeriod: timePeriod,
            pattern: pattern,
            currentValue: measurement
        )
    }
}