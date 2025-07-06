import Foundation

public struct HealthAlert: Codable, Equatable, Sendable {
    public let id: UUID
    public let timePeriod: TimePeriod
    public let pattern: HealthPattern
    public let currentValue: WeatherMeasurementValue
    
    public init(
        id: UUID = UUID(),
        timePeriod: TimePeriod,
        pattern: HealthPattern,
        currentValue: WeatherMeasurementValue
    ) {
        self.id = id
        self.timePeriod = timePeriod
        self.pattern = pattern
        self.currentValue = currentValue
    }
} 