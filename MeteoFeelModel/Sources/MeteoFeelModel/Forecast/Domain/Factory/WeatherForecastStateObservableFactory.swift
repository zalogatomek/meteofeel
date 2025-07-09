import Foundation

public struct WeatherForecastStateObservableFactory {
    
    // MARK: - Factory Methods
    
    public static func create(
        apiKey: String,
        calendar: Calendar = .current
    ) -> WeatherForecastStateObservable {
        let weatherApiClient = WeatherAPIClient(apiKey: apiKey)
        let weatherService = WeatherService(apiClient: weatherApiClient)
        let healthPatternStore = HealthPatternStore()
        let weatherForecastService = WeatherForecastService(
            weatherService: weatherService,
            healthPatternStore: healthPatternStore
        )
        let weatherForecastStore = WeatherForecastStore()
        
        return WeatherForecastStateObservable(
            service: weatherForecastService,
            store: weatherForecastStore,
            calendar: calendar
        )
    }
} 
