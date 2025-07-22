import Foundation

public enum WeatherForecastServiceError: Error {
    case weatherServiceError(WeatherServiceError)
    case healthPatternStoreError(Error)
    case mappingError
    case noLocationAvailable
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
        var allAlerts: [HealthAlert] = []
        
        for pattern in patterns {
            let currentValue = getCurrentValue(for: pattern.value.parameter, from: weather)
            let previousValue = previousWeather.map { getCurrentValue(for: pattern.value.parameter, from: $0) }
            
            guard HealthPatternCalculator.calculate(
                pattern: pattern,
                currentValue: currentValue,
                previousValue: previousValue
            ) else { continue }
            
            let alert = HealthAlert(
                timePeriod: weather.timePeriod,
                pattern: pattern,
                currentValue: currentValue
            )
            allAlerts.append(alert)
        }
        
        return filterRedundantAlerts(allAlerts).sorted()
    }
    
    private func filterRedundantAlerts(_ alerts: [HealthAlert]) -> [HealthAlert] {
        var groupedAlerts: [String: [HealthAlert]] = [:]
        
        for alert in alerts {
            let key = "\(alert.pattern.healthIssue.rawValue)_\(alert.pattern.value.parameter.rawValue)"
            groupedAlerts[key, default: []].append(alert)
        }

        var result: [HealthAlert] = []
        for alertGroup in groupedAlerts.values {
            if let highestRiskAlert = alertGroup.max(by: { $0.pattern.risk < $1.pattern.risk }) {
                result.append(highestRiskAlert)
            }
        }
        
        return result
    }
    
    private func getCurrentValue(for parameter: WeatherParameter, from weather: Weather) -> WeatherMeasurement {
        switch parameter {
        case .temperature: WeatherMeasurement(parameter: .temperature, value: weather.temperature)
        case .pressure: WeatherMeasurement(parameter: .pressure, value: weather.pressure)
        case .humidity: WeatherMeasurement(parameter: .humidity, value: weather.humidity)
        case .windSpeed: WeatherMeasurement(parameter: .windSpeed, value: weather.windSpeed)
        case .windDirection: WeatherMeasurement(parameter: .windDirection, value: weather.windDirection)
        case .weatherCondition: WeatherMeasurement(parameter: .weatherCondition, value: Double(weather.condition.rawValue))
        }
    }
} 
