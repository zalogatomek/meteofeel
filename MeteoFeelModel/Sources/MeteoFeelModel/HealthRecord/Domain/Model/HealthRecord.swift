import Foundation

public struct HealthRecord: Codable, Equatable, Sendable {
    public let date: Date
    public let weatherForecasts: [Weather]
    public let healthStatus: HealthStatus
    
    public init(
        date: Date,
        weatherForecasts: [Weather],
        healthStatus: HealthStatus
    ) {
        self.date = date
        self.weatherForecasts = weatherForecasts
        self.healthStatus = healthStatus
    }
} 