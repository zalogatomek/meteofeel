import Foundation
@testable public import MeteoFeelModel

public final class MockWeatherForecastService: WeatherForecastServiceProtocol, @unchecked Sendable {
    public var forecasts: [WeatherForecast] = []
    public var getForecastsCallCount = 0
    public var shouldThrowError = false
    
    public init() {}
    
    public func getForecasts(coordinates: Coordinates, days: Int) async throws -> [WeatherForecast] {
        getForecastsCallCount += 1
        
        if shouldThrowError {
            throw WeatherForecastServiceError.mappingError
        }
        
        return forecasts
    }
}
