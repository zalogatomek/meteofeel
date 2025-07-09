import Foundation

public enum WeatherForecastServiceError: Error {
    case weatherServiceError(WeatherServiceError)
    case healthPatternStoreError(Error)
    case mappingError
}

protocol WeatherForecastServiceProtocol: Sendable {
    func getForecasts(coordinates: Coordinates, days: Int) async throws -> [WeatherForecast]
}

final class WeatherForecastService: WeatherForecastServiceProtocol {

    // MARK: - Properties

    private let weatherService: WeatherServiceProtocol
    private let healthPatternStore: HealthPatternStoreProtocol
    
    // MARK: - Lifecycle
    
    init(
        weatherService: WeatherServiceProtocol,
        healthPatternStore: HealthPatternStoreProtocol
    ) {
        self.weatherService = weatherService
        self.healthPatternStore = healthPatternStore
    }

    // MARK: - WeatherForecastServiceProtocol
    
    func getForecasts(coordinates: Coordinates, days: Int) async throws -> [WeatherForecast] {
        do {
            async let weatherData = weatherService.getForecast(coordinates: coordinates, days: days)
            async let healthPatterns = healthPatternStore.getPatterns()
            
            let (weather, patterns) = try await (weatherData, healthPatterns)

            return generateForecastsWithAlerts(from: weather, using: patterns)
        } catch let error as WeatherServiceError {
            throw WeatherForecastServiceError.weatherServiceError(error)
        } catch {
            throw WeatherForecastServiceError.healthPatternStoreError(error)
        }
    }

    // MARK: - Helpers
    
    private func generateForecastsWithAlerts(from weather: [Weather], using patterns: [HealthPattern]) -> [WeatherForecast] {
        var forecasts: [WeatherForecast] = []
        var previousWeather: Weather?
        
        for currentWeather in weather {
            let alerts = generateAlerts(
                for: currentWeather,
                using: patterns,
                previousWeather: previousWeather
            )
            
            let forecast = WeatherForecast(weather: currentWeather, alerts: alerts)
            forecasts.append(forecast)
            
            previousWeather = currentWeather
        }
        
        return forecasts
    }
    
    private func generateAlerts(
        for weather: Weather,
        using patterns: [HealthPattern],
        previousWeather: Weather?
    ) -> [HealthAlert] {
        patterns.compactMap { pattern in
            guard let currentValue = getCurrentValue(for: pattern.parameter, from: weather) else {
                return nil
            }
            
            let previousValue = previousWeather.flatMap { getCurrentValue(for: pattern.parameter, from: $0) }
            
            guard HealthPatternCalculator.calculate(
                pattern: pattern,
                currentValue: currentValue,
                previousValue: previousValue
            ) else { return nil }
            
            return HealthAlert(
                timePeriod: weather.timePeriod,
                pattern: pattern,
                currentValue: currentValue
            )
        }
    }
    
    private func getCurrentValue(for parameter: WeatherParameter, from weather: Weather) -> WeatherMeasurementValue? {
        switch parameter {
        case .temperature: .temperature(weather.temperature)
        case .pressure: .pressure(weather.pressure)
        case .humidity: .humidity(weather.humidity)
        case .windSpeed: .windSpeed(weather.windSpeed)
        case .windDirection: .windDirection(weather.windDirection)
        // TODO: weatherCondition for now is not directly available from Weather
        case .weatherCondition: nil 
        }
    }
} 
