import Foundation

public struct WeatherForecastStateObservableFactory {
    
    // MARK: - Factory Methods
    
    public static func create(apiKey: String) -> WeatherForecastStateObservable {
        let refreshService = WeatherForecastRefreshServiceFactory.create(apiKey: apiKey)
        let weatherForecastStore = WeatherForecastStore()
        let profileService = ProfileServiceFactory.create()
        
        return WeatherForecastStateObservable(
            refreshService: refreshService,
            store: weatherForecastStore,
            getUserProfile: { await profileService.loadProfile() }
        )
    }
} 
