import Testing
import Foundation
@testable import MeteoFeelModel
import MeteoFeelModelTestUtilities

final class WeatherForecastRefreshServiceTests {
    
    // MARK: - Properties
    
    private var mockService: MockWeatherForecastService!
    private var mockStore: MockWeatherForecastStore!
    private var mockProfileService: MockProfileService!
    private var refreshService: WeatherForecastRefreshService!
    private var calendar: Calendar!
    
    // MARK: - Setup
    
    init() {
        setupMocks()
    }
    
    private func setupMocks() {
        mockService = MockWeatherForecastService()
        mockStore = MockWeatherForecastStore()
        mockProfileService = MockProfileService()
        calendar = Calendar.current
        
        refreshService = WeatherForecastRefreshService(
            service: mockService,
            store: mockStore,
            calendar: calendar,
            getUserProfile: { @Sendable [mockProfileService] in await mockProfileService!.loadProfile() }
        )
    }
    
    // MARK: - Tests - Should Refresh Logic
    
    @Test func shouldRefreshForecasts_whenNoForecastsAvailable_returnsTrue() async throws {
        mockStore.forecasts = []
        
        let shouldRefresh = await refreshService.shouldRefreshForecasts()
        
        #expect(shouldRefresh == true)
    }
    
    @Test func shouldRefreshForecasts_whenMostRecentForecastIsFromToday_returnsFalse() async throws {
        let today = Date()
        let forecast = WeatherForecast.createStub(
            weather: Weather.createStub(fetchedAt: today)
        )
        mockStore.forecasts = [forecast]
        
        let shouldRefresh = await refreshService.shouldRefreshForecasts()
        
        #expect(shouldRefresh == false)
    }
    
    @Test func shouldRefreshForecasts_whenMostRecentForecastIsFromYesterday_returnsTrue() async throws {
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
        let forecast = WeatherForecast.createStub(
            weather: Weather.createStub(fetchedAt: yesterday)
        )
        mockStore.forecasts = [forecast]
        
        let shouldRefresh = await refreshService.shouldRefreshForecasts()
        
        #expect(shouldRefresh == true)
    }
    
    @Test func shouldRefreshForecasts_whenMostRecentForecastIsFromLastWeek_returnsTrue() async throws {
        let lastWeek = calendar.date(byAdding: .day, value: -7, to: Date())!
        let forecast = WeatherForecast.createStub(
            weather: Weather.createStub(fetchedAt: lastWeek)
        )
        mockStore.forecasts = [forecast]
        
        let shouldRefresh = await refreshService.shouldRefreshForecasts()
        
        #expect(shouldRefresh == true)
    }
    
    // MARK: - Tests - Refresh Forecasts
    
    @Test func refreshForecasts_whenUserProfileExists_callsServiceAndSavesForecasts() async throws {
        let userProfile = UserProfile.createStub()
        mockProfileService.profile = userProfile
        let forecasts = [WeatherForecast.createStub()]
        mockService.forecasts = forecasts
        
        try await refreshService.refreshForecasts()
        
        #expect(mockService.getForecastsCallCount == 1)
        #expect(mockStore.saveForecastsCallCount == 1)
        #expect(mockStore.savedForecasts == forecasts)
    }
    
    @Test func refreshForecasts_whenUserProfileDoesNotExist_throwsNoLocationAvailableError() async throws {
        mockProfileService.profile = nil
        
        await #expect(throws: WeatherForecastServiceError.self) {
            try await self.refreshService.refreshForecasts()
        }
    }
    
    @Test func refreshForecasts_whenServiceThrowsError_propagatesError() async throws {
        let userProfile = UserProfile.createStub()
        mockProfileService.profile = userProfile
        mockService.shouldThrowError = true
        
        await #expect(throws: WeatherForecastServiceError.self) {
            try await self.refreshService.refreshForecasts()
        }
    }
    
    @Test func refreshForecasts_whenStoreThrowsError_propagatesError() async throws {
        let userProfile = UserProfile.createStub()
        mockProfileService.profile = userProfile
        let forecasts = [WeatherForecast.createStub()]
        mockService.forecasts = forecasts
        mockStore.shouldThrowError = true
        
        await #expect(throws: WeatherForecastStoreError.self) {
            try await self.refreshService.refreshForecasts()
        }
    }
}
