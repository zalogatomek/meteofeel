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
        currentValue: WeatherMeasurement,
        previousValue: WeatherMeasurement? = nil,
        currentTimePeriod: TimePeriod,
        previousTimePeriod: TimePeriod? = nil
    ) -> Bool {
        if shouldSkipRapidChange(pattern: pattern, currentTimePeriod: currentTimePeriod, previousTimePeriod: previousTimePeriod) {
            return false
        }
        
        switch (pattern.condition, pattern.value.parameter, currentValue, previousValue) {
        case (.above, .temperature, let current, _):
            return current.value > pattern.value.value
        case (.below, .temperature, let current, _):
            return current.value < pattern.value.value
        case (.equals, .temperature, let current, _):
            return abs(current.value - pattern.value.value) < temperatureTolerance
        case (.rapidIncrease, .temperature, let current, let previous):
            guard let previous = previous, case .temperature = previous.parameter else { return false }
            return (current.value - previous.value) >= pattern.value.value
        case (.rapidDecrease, .temperature, let current, let previous):
            guard let previous = previous, case .temperature = previous.parameter else { return false }
            return (previous.value - current.value) >= pattern.value.value
            
        case (.above, .pressure, let current, _):
            return current.value > pattern.value.value
        case (.below, .pressure, let current, _):
            return current.value < pattern.value.value
        case (.equals, .pressure, let current, _):
            return abs(current.value - pattern.value.value) < pressureTolerance
        case (.rapidIncrease, .pressure, let current, let previous):
            guard let previous = previous, case .pressure = previous.parameter else { return false }
            return (current.value - previous.value) >= pattern.value.value
        case (.rapidDecrease, .pressure, let current, let previous):
            guard let previous = previous, case .pressure = previous.parameter else { return false }
            return (previous.value - current.value) >= pattern.value.value
            
        case (.above, .humidity, let current, _):
            return current.value > pattern.value.value
        case (.below, .humidity, let current, _):
            return current.value < pattern.value.value
        case (.equals, .humidity, let current, _):
            return abs(current.value - pattern.value.value) < humidityTolerance
        case (.rapidIncrease, .humidity, let current, let previous):
            guard let previous = previous, case .humidity = previous.parameter else { return false }
            return (current.value - previous.value) >= pattern.value.value
        case (.rapidDecrease, .humidity, let current, let previous):
            guard let previous = previous, case .humidity = previous.parameter else { return false }
            return (previous.value - current.value) >= pattern.value.value
            
        case (.above, .windSpeed, let current, _):
            return current.value > pattern.value.value
        case (.below, .windSpeed, let current, _):
            return current.value < pattern.value.value
        case (.equals, .windSpeed, let current, _):
            return abs(current.value - pattern.value.value) < windSpeedTolerance
        case (.rapidIncrease, .windSpeed, let current, let previous):
            guard let previous = previous, case .windSpeed = previous.parameter else { return false }
            return (current.value - previous.value) >= pattern.value.value
        case (.rapidDecrease, .windSpeed, let current, let previous):
            guard let previous = previous, case .windSpeed = previous.parameter else { return false }
            return (previous.value - current.value) >= pattern.value.value
            
        case (.above, .windDirection, let current, _):
            return current.value > pattern.value.value
        case (.below, .windDirection, let current, _):
            return current.value < pattern.value.value
        case (.equals, .windDirection, let current, _):
            return abs(current.value - pattern.value.value) < windDirectionTolerance
        case (.rapidIncrease, .windDirection, let current, let previous):
            guard let previous = previous, case .windDirection = previous.parameter else { return false }
            return (current.value - previous.value) >= pattern.value.value
        case (.rapidDecrease, .windDirection, let current, let previous):
            guard let previous = previous, case .windDirection = previous.parameter else { return false }
            return (previous.value - current.value) >= pattern.value.value
            
        case (.equals, .weatherCondition, let current, _):
            return current.value == pattern.value.value
            
        default:
            return false
        }
    }

    // MARK: - Private Helpers

    private static func shouldSkipRapidChange(
        pattern: HealthPattern,
        currentTimePeriod: TimePeriod,
        previousTimePeriod: TimePeriod?
    ) -> Bool {
        guard let previousTimePeriod else { return false }
        return previousTimePeriod.hasGap(to: currentTimePeriod)
            && (pattern.condition == .rapidIncrease || pattern.condition == .rapidDecrease)
    }
} 
