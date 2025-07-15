import Foundation

public struct WeatherForecast: Codable, Equatable, Sendable, Identifiable {
    public let id: UUID
    public let weather: Weather
    public let alerts: [HealthAlert]
    
    public init(weather: Weather, alerts: [HealthAlert]) {
        self.id = UUID()
        self.weather = weather
        self.alerts = alerts
    }
} 