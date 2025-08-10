import Foundation

public enum WeatherForecastRefreshServiceFactory {

    // MARK: - Create
    
    public static func create(apiKey: String) -> any WeatherForecastRefreshServiceProtocol {
        let weatherApiClient = WeatherAPIClient(apiKey: apiKey)
        let weatherService = WeatherService(apiClient: weatherApiClient)
        let healthPatternStore = HealthPatternStore()
        let weatherForecastService = WeatherForecastService(
            weatherService: weatherService,
            healthPatternStore: healthPatternStore
        )
        let weatherForecastStore = WeatherForecastStore()
        let profileService = ProfileServiceFactory.create()
        
        return WeatherForecastRefreshService(
            service: weatherForecastService,
            store: weatherForecastStore,
            calendar: .current,
            getUserProfile: { await profileService.loadProfile() }
        )
    }
}
