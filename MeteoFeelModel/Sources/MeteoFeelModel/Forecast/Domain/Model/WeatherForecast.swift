public import Foundation

public struct WeatherForecast: Codable, Equatable, Sendable, Identifiable {

    // MARK: - Properties

    public let id: UUID
    public let weather: Weather
    public let alerts: [HealthAlert]

    // MARK: - Lifecycle
    
    public init(weather: Weather, alerts: [HealthAlert]) {
        self.id = UUID()
        self.weather = weather
        self.alerts = alerts
    }
    
    // MARK: - Filtering
    
    public func byFilteringHealthIssues(_ healthIssues: Set<HealthIssue>) -> WeatherForecast {
        guard !healthIssues.isEmpty else { return self }
        
        let filteredAlerts = alerts.filter { alert in
            healthIssues.contains(alert.pattern.healthIssue)
        }
        
        return WeatherForecast(weather: weather, alerts: filteredAlerts)
    }
} 
