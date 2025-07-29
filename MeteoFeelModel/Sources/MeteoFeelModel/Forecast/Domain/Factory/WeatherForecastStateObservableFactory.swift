public import Foundation

public struct WeatherForecastStateObservableFactory {
    
    // MARK: - Factory Methods
    
    public static func create(
        apiKey: String,
        profileService: any ProfileServiceProtocol,
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
            getUserProfile: { await profileService.loadProfile() },
            calendar: calendar
        )
    }
} 
