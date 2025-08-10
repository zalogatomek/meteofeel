public import Foundation
@testable public import MeteoFeelModel

public final class MockWeatherForecastStore: WeatherForecastStoreProtocol, @unchecked Sendable {
    public var forecasts: [WeatherForecast] = []
    public var saveForecastsCallCount = 0
    public var savedForecasts: [WeatherForecast] = []
    public var shouldThrowError = false
    
    public init() {}
    
    public func saveForecasts(_ forecasts: [WeatherForecast]) async throws {
        saveForecastsCallCount += 1
        
        if shouldThrowError {
            throw WeatherForecastStoreError.saveError
        }
        
        savedForecasts = forecasts
    }
    
    public func getForecast(for date: Date) async throws -> WeatherForecast? {
        return forecasts.first
    }
    
    public func getForecast(for timePeriod: TimePeriod) async throws -> WeatherForecast? {
        return forecasts.first
    }
    
    public func getForecasts(for periods: [TimePeriod]) async throws -> [WeatherForecast] {
        return forecasts
    }
    
    public func getForecasts(for date: Date, nextPeriods count: Int) async throws -> [WeatherForecast] {
        return forecasts
    }
    
    public func getHistoricalForecasts(from startDate: Date, to endDate: Date) async throws -> [WeatherForecast] {
        return forecasts
    }
    
    public func cleanupOldData(olderThan date: Date) async throws {
        // No-op for tests
    }
}
