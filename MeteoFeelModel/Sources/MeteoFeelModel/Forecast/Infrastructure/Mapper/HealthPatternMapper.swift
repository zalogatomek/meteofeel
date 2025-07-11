import Foundation

enum HealthPatternMapper {
    static func map(_ response: HealthPatternResponse) -> [HealthPattern] {
        response.patterns?.flatMap { pattern in
            guard let healthIssue = mapHealthIssue(pattern.healthIssue),
                  let parameter = mapParameter(pattern.parameter),
                  let condition = mapCondition(pattern.condition),
                  let thresholds = pattern.thresholds
            else { return [HealthPattern]() }
            
            var patterns: [HealthPattern] = []
            
            // Generate high risk pattern if threshold exists
            if let highThreshold = thresholds.high {
                let value = WeatherMeasurement(parameter: parameter, value: highThreshold)
                patterns.append(HealthPattern(
                    healthIssue: healthIssue,
                    condition: condition,
                    value: value,
                    risk: .high
                ))
            }
            
            // Generate medium risk pattern if threshold exists
            if let mediumThreshold = thresholds.medium {
                let value = WeatherMeasurement(parameter: parameter, value: mediumThreshold)
                patterns.append(HealthPattern(
                    healthIssue: healthIssue,
                    condition: condition,
                    value: value,
                    risk: .medium
                ))
            }
            
            return patterns
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
} 
