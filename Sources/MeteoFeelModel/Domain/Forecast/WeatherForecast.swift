import Foundation

public struct WeatherForecast: Codable, Equatable {
    public let weather: Weather
    public let alerts: [HealthAlert]
    
    public init(weather: Weather, alerts: [HealthAlert]) {
        self.weather = weather
        self.alerts = alerts
    }
} 