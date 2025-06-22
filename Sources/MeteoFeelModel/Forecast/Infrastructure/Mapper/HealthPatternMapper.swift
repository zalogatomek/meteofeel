import Foundation

enum HealthPatternMapper {
    static func map(_ response: HealthPatternResponse) -> [HealthPattern] {
        response.patterns?.compactMap { pattern in
            guard let healthIssue = mapHealthIssue(pattern.healthIssue),
                  let parameter = mapParameter(pattern.parameter),
                  let condition = mapCondition(pattern.condition),
                  let value = mapValue(value: pattern.value, weatherCondition: pattern.weatherCondition, parameter: parameter),
                  let risk = mapRisk(pattern.risk)
            else { return nil }
            
            return HealthPattern(
                healthIssue: healthIssue,
                parameter: parameter,
                condition: condition,
                value: value,
                risk: risk
            )
        } ?? []
    }
    
    private static func mapHealthIssue(_ response: HealthIssueResponse?) -> HealthIssue? {
        switch response {
        case .headache: .headache
        case .jointPain: .jointPain
        case .respiratory: .respiratory
        case .fatigue: .fatigue
        case .allergy: .allergy
        case .asthma: .asthma
        case .mood: .mood
        case .cardiovascular: .cardiovascular
        case .skin: .skin
        case .unknown, nil: nil
        }
    }
    
    private static func mapParameter(_ response: WeatherParameterResponse?) -> WeatherParameter? {
        switch response {
        case .temperature: .temperature
        case .pressure: .pressure
        case .humidity: .humidity
        case .windSpeed: .windSpeed
        case .windDirection: .windDirection
        case .weatherCondition: .weatherCondition
        case .unknown, nil: nil
        }
    }
    
    private static func mapCondition(_ response: HealthPatternConditionResponse?) -> HealthPatternCondition? {
        switch response {
        case .above: .above
        case .below: .below
        case .rapidIncrease: .rapidIncrease
        case .rapidDecrease: .rapidDecrease
        case .equals: .equals
        case .unknown, nil: nil
        }
    }
    
    private static func mapRisk(_ response: HealthRiskResponse?) -> HealthRisk? {
        switch response {
        case .medium: .medium
        case .high: .high
        case .unknown, nil: nil
        }
    }

    private static func mapValue(
        value: Double?,
        weatherCondition: WeatherConditionResponse?,
        parameter: WeatherParameter
    ) -> WeatherMeasurementValue? {
        if parameter != .weatherCondition, let value = value {
            return mapValue(value: value, parameter: parameter)
        } else if parameter == .weatherCondition, let weatherCondition = mapWeatherCondition(weatherCondition) {
            return .weatherCondition(weatherCondition)
        } else {
            return nil
        }
    }

    private static func mapValue(value: Double?, parameter: WeatherParameter) -> WeatherMeasurementValue? {
        guard let value = value else { return nil }

        return switch parameter {
        case .temperature: .temperature(Measurement(value: value, unit: UnitTemperature.celsius))
        case .pressure: .pressure(Measurement(value: value, unit: UnitPressure.millibars))
        case .humidity: .humidity(value)
        case .windSpeed: .windSpeed(Measurement(value: value, unit: UnitSpeed.kilometersPerHour))
        case .windDirection: .windDirection(Measurement(value: value, unit: UnitAngle.degrees))
        case .weatherCondition: nil 
        }
    }

    private static func mapWeatherCondition(_ response: WeatherConditionResponse?) -> WeatherCondition? {
        switch response {
        case .sunny: .sunny
        case .partlyCloudy: .partlyCloudy
        case .cloudy: .cloudy
        case .rainy: .rainy
        case .heavyRain: .heavyRain
        case .snowy: .snowy
        case .foggy: .foggy
        case .windy: .windy
        case .thunderstorm: .thunderstorm
        case .unknown, nil: nil
        }
    }
} 