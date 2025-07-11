import Foundation

public struct HealthAlert: Codable, Equatable, Comparable, Sendable {
    public let id: UUID
    public let timePeriod: TimePeriod
    public let pattern: HealthPattern
    public let currentValue: WeatherMeasurement
    
    public init(
        id: UUID = UUID(),
        timePeriod: TimePeriod,
        pattern: HealthPattern,
        currentValue: WeatherMeasurement
    ) {
        self.id = id
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
