import Foundation

struct HealthPatternCalculator {
    
    // MARK: - Constants
    
    private static let temperatureTolerance: Double = 0.1
    private static let pressureTolerance: Double = 0.1
    private static let humidityTolerance: Double = 0.1
    private static let windSpeedTolerance: Double = 0.1
    private static let windDirectionTolerance: Double = 1.0
    
    // MARK: - Calculate
    
    static func calculate(
        pattern: HealthPattern,
        currentValue: WeatherMeasurementValue,
        previousValue: WeatherMeasurementValue? = nil
    ) -> Bool {
        switch (pattern.condition, pattern.value, currentValue, previousValue) {
        case (.above, .temperature(let threshold), .temperature(let current), _):
            return current.value > threshold.value
        case (.below, .temperature(let threshold), .temperature(let current), _):
            return current.value < threshold.value
        case (.equals, .temperature(let threshold), .temperature(let current), _):
            return abs(current.value - threshold.value) < temperatureTolerance
        case (.rapidIncrease, .temperature(let threshold), .temperature(let current), let previous):
            guard let previous = previous, case .temperature(let prev) = previous else { return false }
            return (current.value - prev.value) >= threshold.value
        case (.rapidDecrease, .temperature(let threshold), .temperature(let current), let previous):
            guard let previous = previous, case .temperature(let prev) = previous else { return false }
            return (prev.value - current.value) >= threshold.value
            
        case (.above, .pressure(let threshold), .pressure(let current), _):
            return current.value > threshold.value
        case (.below, .pressure(let threshold), .pressure(let current), _):
            return current.value < threshold.value
        case (.equals, .pressure(let threshold), .pressure(let current), _):
            return abs(current.value - threshold.value) < pressureTolerance
        case (.rapidIncrease, .pressure(let threshold), .pressure(let current), let previous):
            guard let previous = previous, case .pressure(let prev) = previous else { return false }
            return (current.value - prev.value) >= threshold.value
        case (.rapidDecrease, .pressure(let threshold), .pressure(let current), let previous):
            guard let previous = previous, case .pressure(let prev) = previous else { return false }
            return (prev.value - current.value) >= threshold.value
            
        case (.above, .humidity(let threshold), .humidity(let current), _):
            return current > threshold
        case (.below, .humidity(let threshold), .humidity(let current), _):
            return current < threshold
        case (.equals, .humidity(let threshold), .humidity(let current), _):
            return abs(current - threshold) < humidityTolerance
        case (.rapidIncrease, .humidity(let threshold), .humidity(let current), let previous):
            guard let previous = previous, case .humidity(let prev) = previous else { return false }
            return (current - prev) >= threshold
        case (.rapidDecrease, .humidity(let threshold), .humidity(let current), let previous):
            guard let previous = previous, case .humidity(let prev) = previous else { return false }
            return (prev - current) >= threshold
            
        case (.above, .windSpeed(let threshold), .windSpeed(let current), _):
            return current.value > threshold.value
        case (.below, .windSpeed(let threshold), .windSpeed(let current), _):
            return current.value < threshold.value
        case (.equals, .windSpeed(let threshold), .windSpeed(let current), _):
            return abs(current.value - threshold.value) < windSpeedTolerance
        case (.rapidIncrease, .windSpeed(let threshold), .windSpeed(let current), let previous):
            guard let previous = previous, case .windSpeed(let prev) = previous else { return false }
            return (current.value - prev.value) >= threshold.value
        case (.rapidDecrease, .windSpeed(let threshold), .windSpeed(let current), let previous):
            guard let previous = previous, case .windSpeed(let prev) = previous else { return false }
            return (prev.value - current.value) >= threshold.value
            
        case (.above, .windDirection(let threshold), .windDirection(let current), _):
            return current.value > threshold.value
        case (.below, .windDirection(let threshold), .windDirection(let current), _):
            return current.value < threshold.value
        case (.equals, .windDirection(let threshold), .windDirection(let current), _):
            return abs(current.value - threshold.value) < windDirectionTolerance
        case (.rapidIncrease, .windDirection(let threshold), .windDirection(let current), let previous):
            guard let previous = previous, case .windDirection(let prev) = previous else { return false }
            return (current.value - prev.value) >= threshold.value
        case (.rapidDecrease, .windDirection(let threshold), .windDirection(let current), let previous):
            guard let previous = previous, case .windDirection(let prev) = previous else { return false }
            return (prev.value - current.value) >= threshold.value
            
        case (.equals, .weatherCondition(let threshold), .weatherCondition(let current), _):
            return current == threshold
            
        default:
            return false
        }
    }
} 