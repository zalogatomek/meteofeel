import Foundation

public protocol WeatherForecastRefreshServiceProtocol: Sendable {
    func shouldRefreshForecasts() async -> Bool
    func refreshForecasts() async throws
}

public actor WeatherForecastRefreshService: WeatherForecastRefreshServiceProtocol {
    
    // MARK: - Properties
    
    private let service: any WeatherForecastServiceProtocol
    private let store: any WeatherForecastStoreProtocol
    private let calendar: Calendar
    private let getUserProfile: () async -> UserProfile?
    
    // MARK: - Lifecycle
    
    init(
        service: any WeatherForecastServiceProtocol,
        store: any WeatherForecastStoreProtocol,
        calendar: Calendar = .current,
        getUserProfile: @escaping () async -> UserProfile?
    ) {
        self.service = service
        self.store = store
        self.calendar = calendar
        self.getUserProfile = getUserProfile
    }
    
    // MARK: - WeatherForecastRefreshServiceProtocol
    
    public func shouldRefreshForecasts() async -> Bool {
        do {
            let forecasts = try await store.getForecasts(for: Date(), nextPeriods: 3)
            
            guard let mostRecentForecast = forecasts.max(by: { $0.weather.fetchedAt < $1.weather.fetchedAt }) else {
                return true // No forecasts available, should refresh
            }
            
            return !calendar.isDateInToday(mostRecentForecast.weather.fetchedAt)
        } catch {
            return true // Error occurred, should refresh
        }
    }
    
    public func refreshForecasts() async throws {
        guard let userProfile = await getUserProfile() else {
            throw WeatherForecastServiceError.noLocationAvailable
        }
        
        let forecasts = try await service.getForecasts(
            coordinates: userProfile.location.coordinates,
            days: 3
        )
        
        try await store.saveForecasts(forecasts)
    }
}