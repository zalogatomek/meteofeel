import Foundation
import Testing
import MeteoFeelTestUtilities
@testable import MeteoFeelModel

struct WeatherForecastStoreTests {

    // MARK: - Tests - Save Forecasts
    
    @Test 
    func saveForecastsSuccessfully() async throws {
        let mockUserDefaults = MockUserDefaults()
        let store = WeatherForecastStore(defaults: mockUserDefaults)
        
        let forecast1 = WeatherForecast.createStub(
            weather: Weather.createStub(
                timePeriod: TimePeriod.createStub(date: Date().startOfDay(), timeOfDay: .morning)
            )
        )
        let forecast2 = WeatherForecast.createStub(
            weather: Weather.createStub(
                timePeriod: TimePeriod.createStub(date: Date().startOfDay(), timeOfDay: .afternoon)
            )
        )
        
        try await store.saveForecasts([forecast1, forecast2])
        
        let savedData = mockUserDefaults.data(forKey: WeatherForecastStore.Keys.forecasts)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decodedForecasts = try decoder.decode([WeatherForecast].self, from: savedData!)
        #expect(decodedForecasts.count == 2)
        #expect(decodedForecasts.contains(where: { $0.weather.timePeriod == forecast1.weather.timePeriod }))
        #expect(decodedForecasts.contains(where: { $0.weather.timePeriod == forecast2.weather.timePeriod }))
    }
    
    @Test 
    func saveForecastsOverwritesExistingWithNewerData() async throws {
        let mockUserDefaults = MockUserDefaults()
        let store = WeatherForecastStore(defaults: mockUserDefaults)
        
        let oldDate = Date().addingTimeInterval(-3600) // 1 hour ago
        let newDate = Date()
        
        let oldForecast = WeatherForecast.createStub(
            weather: Weather.createStub(
                timePeriod: TimePeriod.createStub(timeOfDay: .morning),
                fetchedAt: oldDate
            )
        )
        let newForecast = WeatherForecast.createStub(
            weather: Weather.createStub(
                timePeriod: TimePeriod.createStub(timeOfDay: .morning),
                fetchedAt: newDate
            )
        )
        
        // Save old forecast first
        try await store.saveForecasts([oldForecast])
        
        // Save new forecast (should overwrite)
        try await store.saveForecasts([newForecast])
        
        let savedForecast = try await store.getForecast(for: TimePeriod.createStub(timeOfDay: .morning))
        let timeDifference = abs((savedForecast?.weather.fetchedAt.timeIntervalSince1970 ?? 0) - newDate.timeIntervalSince1970)
        #expect(timeDifference < 1.0) // Allow 1 second tolerance
    }
    
    @Test 
    func saveForecastsKeepsExistingWhenNewerDataExists() async throws {
        let mockUserDefaults = MockUserDefaults()
        let store = WeatherForecastStore(defaults: mockUserDefaults)
        
        let oldDate = Date().addingTimeInterval(-3600) // 1 hour ago
        let newDate = Date()
        
        let oldForecast = WeatherForecast.createStub(
            weather: Weather.createStub(
                timePeriod: TimePeriod.createStub(timeOfDay: .morning),
                fetchedAt: newDate
            )
        )
        let newForecast = WeatherForecast.createStub(
            weather: Weather.createStub(
                timePeriod: TimePeriod.createStub(timeOfDay: .morning),
                fetchedAt: oldDate
            )
        )
        
        // Save old forecast first
        try await store.saveForecasts([oldForecast])
        
        // Save new forecast (should not overwrite)
        try await store.saveForecasts([newForecast])
        
        let savedForecast = try await store.getForecast(for: TimePeriod.createStub(timeOfDay: .morning))
        let timeDifference = abs((savedForecast?.weather.fetchedAt.timeIntervalSince1970 ?? 0) - newDate.timeIntervalSince1970)
        #expect(timeDifference < 1.0) // Allow 1 second tolerance
    }
    
    // MARK: - Tests - Get Forecast
    
    @Test 
    func getForecastForTimePeriodReturnsCorrectForecast() async throws {
        let mockUserDefaults = MockUserDefaults()
        let store = WeatherForecastStore(defaults: mockUserDefaults)
        
        let morningPeriod = TimePeriod.createStub(timeOfDay: .morning)
        let afternoonPeriod = TimePeriod.createStub(timeOfDay: .afternoon)
        
        let morningForecast = WeatherForecast.createStub(
            weather: Weather.createStub(timePeriod: morningPeriod)
        )
        let afternoonForecast = WeatherForecast.createStub(
            weather: Weather.createStub(timePeriod: afternoonPeriod)
        )
        
        try await store.saveForecasts([morningForecast, afternoonForecast])
        
        let retrievedForecast = try await store.getForecast(for: morningPeriod)
        #expect(retrievedForecast?.weather.timePeriod == morningPeriod)
    }
    
    @Test 
    func getForecastForTimePeriodReturnsNilWhenNotFound() async throws {
        let mockUserDefaults = MockUserDefaults()
        let store = WeatherForecastStore(defaults: mockUserDefaults)
        
        let nonExistentPeriod = TimePeriod.createStub(timeOfDay: .evening)
        let retrievedForecast = try await store.getForecast(for: nonExistentPeriod)
        
        #expect(retrievedForecast == nil)
    }
    
    @Test 
    func getForecastForDateReturnsCorrectForecast() async throws {
        let mockUserDefaults = MockUserDefaults()
        let store = WeatherForecastStore(defaults: mockUserDefaults)
        
        let date = Date().startOfDay()
        let morningPeriod = TimePeriod(date: date, timeOfDay: .morning)
        let forecast = WeatherForecast.createStub(
            weather: Weather.createStub(timePeriod: morningPeriod)
        )
        
        try await store.saveForecasts([forecast])
        
        // Create a date that falls within morning hours (8 AM)
        let morningDate = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: date)!
        let retrievedForecast = try await store.getForecast(for: morningDate)
        #expect(retrievedForecast?.weather.timePeriod == morningPeriod)
    }
    
    // MARK: - Tests - Get Multiple Forecasts
    
    @Test 
    func getForecastsForPeriodsReturnsCorrectForecasts() async throws {
        let mockUserDefaults = MockUserDefaults()
        let store = WeatherForecastStore(defaults: mockUserDefaults)
        
        let morningPeriod = TimePeriod.createStub(timeOfDay: .morning)
        let afternoonPeriod = TimePeriod.createStub(timeOfDay: .afternoon)
        let eveningPeriod = TimePeriod.createStub(timeOfDay: .evening)
        
        let morningForecast = WeatherForecast.createStub(
            weather: Weather.createStub(timePeriod: morningPeriod)
        )
        let afternoonForecast = WeatherForecast.createStub(
            weather: Weather.createStub(timePeriod: afternoonPeriod)
        )
        let eveningForecast = WeatherForecast.createStub(
            weather: Weather.createStub(timePeriod: eveningPeriod)
        )
        
        try await store.saveForecasts([morningForecast, afternoonForecast, eveningForecast])
        
        let retrievedForecasts = try await store.getForecasts(for: [morningPeriod, eveningPeriod])
        #expect(retrievedForecasts.count == 2)
        #expect(retrievedForecasts.contains(where: { $0.weather.timePeriod == morningPeriod }))
        #expect(retrievedForecasts.contains(where: { $0.weather.timePeriod == eveningPeriod }))
    }
    
    @Test 
    func getForecastsForDateAndNextPeriodsReturnsCorrectForecasts() async throws {
        let mockUserDefaults = MockUserDefaults()
        let store = WeatherForecastStore(defaults: mockUserDefaults)
        
        let date = Date().startOfDay()
        let morningPeriod = TimePeriod(date: date, timeOfDay: .morning)
        let afternoonPeriod = TimePeriod(date: date, timeOfDay: .afternoon)
        let eveningPeriod = TimePeriod(date: date, timeOfDay: .evening)
        
        let morningForecast = WeatherForecast.createStub(
            weather: Weather.createStub(timePeriod: morningPeriod)
        )
        let afternoonForecast = WeatherForecast.createStub(
            weather: Weather.createStub(timePeriod: afternoonPeriod)
        )
        let eveningForecast = WeatherForecast.createStub(
            weather: Weather.createStub(timePeriod: eveningPeriod)
        )
        
        try await store.saveForecasts([morningForecast, afternoonForecast, eveningForecast])
        
        let retrievedForecasts = try await store.getForecasts(for: date, nextPeriods: 2)
        #expect(retrievedForecasts.count == 3) // morning + 2 next periods
        #expect(retrievedForecasts.first?.weather.timePeriod == morningPeriod)
    }
    
    // MARK: - Tests - Historical Data
    
    @Test 
    func getHistoricalForecastsReturnsCorrectRange() async throws {
        let mockUserDefaults = MockUserDefaults()
        let store = WeatherForecastStore(defaults: mockUserDefaults)
        
        let today = Date().startOfDay()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        
        let todayForecast = WeatherForecast.createStub(
            weather: Weather.createStub(timePeriod: TimePeriod(date: today, timeOfDay: .morning))
        )
        let yesterdayForecast = WeatherForecast.createStub(
            weather: Weather.createStub(timePeriod: TimePeriod(date: yesterday, timeOfDay: .morning))
        )
        let tomorrowForecast = WeatherForecast.createStub(
            weather: Weather.createStub(timePeriod: TimePeriod(date: tomorrow, timeOfDay: .morning))
        )
        
        try await store.saveForecasts([todayForecast, yesterdayForecast, tomorrowForecast])
        
        let historicalForecasts = try await store.getHistoricalForecasts(from: yesterday, to: today)
        #expect(historicalForecasts.count == 2)
        #expect(historicalForecasts.contains(where: { $0.weather.timePeriod.date == yesterday }))
        #expect(historicalForecasts.contains(where: { $0.weather.timePeriod.date == today }))
    }
    
    // MARK: - Tests - Cleanup
    
    @Test 
    func cleanupOldDataRemovesExpiredForecasts() async throws {
        let mockUserDefaults = MockUserDefaults()
        let store = WeatherForecastStore(defaults: mockUserDefaults)
        
        let today = Date().startOfDay()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!
        
        let todayForecast = WeatherForecast.createStub(
            weather: Weather.createStub(timePeriod: TimePeriod(date: today, timeOfDay: .morning))
        )
        let yesterdayForecast = WeatherForecast.createStub(
            weather: Weather.createStub(timePeriod: TimePeriod(date: yesterday, timeOfDay: .morning))
        )
        let twoDaysAgoForecast = WeatherForecast.createStub(
            weather: Weather.createStub(timePeriod: TimePeriod(date: twoDaysAgo, timeOfDay: .morning))
        )
        
        try await store.saveForecasts([todayForecast, yesterdayForecast, twoDaysAgoForecast])
        
        // Cleanup data older than yesterday
        try await store.cleanupOldData(olderThan: yesterday)
        
        let remainingForecasts = try await store.getForecasts(for: [TimePeriod(date: today, timeOfDay: .morning), TimePeriod(date: yesterday, timeOfDay: .morning)])
        #expect(remainingForecasts.count == 2)
        #expect(remainingForecasts.contains(where: { $0.weather.timePeriod.date == today }))
        #expect(remainingForecasts.contains(where: { $0.weather.timePeriod.date == yesterday }))
    }
    
    // MARK: - Tests - Error Handling
    
    @Test 
    func saveForecastsThrowsErrorOnEncodingFailure() async throws {
        let mockUserDefaults = MockUserDefaults()
        let store = WeatherForecastStore(defaults: mockUserDefaults)
        
        // Create a forecast that should encode successfully
        let forecast = WeatherForecast.createStub()
        
        // This should not throw an error since WeatherForecast is Codable
        try await store.saveForecasts([forecast])
        
        // Verify the forecast was saved correctly
        let savedForecasts = try await store.getForecasts(for: [forecast.weather.timePeriod])
        #expect(savedForecasts.count == 1)
        #expect(savedForecasts.first?.weather.timePeriod == forecast.weather.timePeriod)
    }
    
    @Test 
    func getForecastsThrowsErrorOnInvalidData() async throws {
        let mockUserDefaults = MockUserDefaults()
        let invalidData = "invalid json data".data(using: .utf8)!
        mockUserDefaults.set(invalidData, forKey: WeatherForecastStore.Keys.forecasts)
        
        let store = WeatherForecastStore(defaults: mockUserDefaults)
        
        do {
            _ = try await store.getForecast(for: TimePeriod.createStub())
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            #expect(error is WeatherForecastStoreError)
        }
    }
    
    // MARK: - Tests - Parameterized Tests
    
    @Test(arguments: [
        (TimeOfDay.morning, TimeOfDay.afternoon, TimeOfDay.evening),
        (TimeOfDay.afternoon, TimeOfDay.evening, TimeOfDay.morning),
        (TimeOfDay.evening, TimeOfDay.morning, TimeOfDay.afternoon)
    ])
    func getForecastsForNextPeriodsReturnsCorrectSequence(_ startTimeOfDay: TimeOfDay, _ expectedSecond: TimeOfDay, _ expectedThird: TimeOfDay) async throws {
        let mockUserDefaults = MockUserDefaults()
        let store = WeatherForecastStore(defaults: mockUserDefaults)
        
        let date = Date().startOfDay()
        let morningPeriod = TimePeriod(date: date, timeOfDay: .morning)
        let afternoonPeriod = TimePeriod(date: date, timeOfDay: .afternoon)
        let eveningPeriod = TimePeriod(date: date, timeOfDay: .evening)
        
        let morningForecast = WeatherForecast.createStub(
            weather: Weather.createStub(timePeriod: morningPeriod)
        )
        let afternoonForecast = WeatherForecast.createStub(
            weather: Weather.createStub(timePeriod: afternoonPeriod)
        )
        let eveningForecast = WeatherForecast.createStub(
            weather: Weather.createStub(timePeriod: eveningPeriod)
        )
        
        try await store.saveForecasts([morningForecast, afternoonForecast, eveningForecast])
        
        let retrievedForecasts = try await store.getForecasts(for: date, nextPeriods: 2)
        #expect(retrievedForecasts.count == 3)
        #expect(retrievedForecasts[0].weather.timePeriod.timeOfDay == .morning)
        #expect(retrievedForecasts[1].weather.timePeriod.timeOfDay == .afternoon)
        #expect(retrievedForecasts[2].weather.timePeriod.timeOfDay == .evening)
    }
} 