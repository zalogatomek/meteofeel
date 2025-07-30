import Foundation
import Testing
@testable import MeteoFeelModel

struct HealthPatternCalculatorTests {

    // MARK: - Tests - Above Condition
    
    @Test(arguments: [
        (WeatherParameter.temperature, 25.0, 30.0, true),
        (WeatherParameter.temperature, 25.0, 20.0, false),
        (WeatherParameter.temperature, 25.0, 25.0, false),
        (WeatherParameter.pressure, 1013.0, 1020.0, true),
        (WeatherParameter.pressure, 1013.0, 1010.0, false),
        (WeatherParameter.humidity, 60.0, 70.0, true),
        (WeatherParameter.humidity, 60.0, 50.0, false),
        (WeatherParameter.windSpeed, 10.0, 15.0, true),
        (WeatherParameter.windSpeed, 10.0, 5.0, false),
        (WeatherParameter.windDirection, 180.0, 200.0, true),
        (WeatherParameter.windDirection, 180.0, 160.0, false)
    ])
    func aboveCondition(_ parameter: WeatherParameter, _ threshold: Double, _ currentValue: Double, _ expected: Bool) throws {
        let pattern = HealthPattern.createStub(
            condition: .above,
            value: WeatherMeasurement.createStub(parameter: parameter, value: threshold)
        )
        let measurement = WeatherMeasurement.createStub(parameter: parameter, value: currentValue)
        
        let result = HealthPatternCalculator.calculate(pattern: pattern, currentValue: measurement)
        
        #expect(result == expected)
    }
    
    // MARK: - Tests - Below Condition
    
    @Test(arguments: [
        (WeatherParameter.temperature, 25.0, 20.0, true),
        (WeatherParameter.temperature, 25.0, 30.0, false),
        (WeatherParameter.temperature, 25.0, 25.0, false),
        (WeatherParameter.pressure, 1013.0, 1010.0, true),
        (WeatherParameter.pressure, 1013.0, 1020.0, false),
        (WeatherParameter.humidity, 60.0, 50.0, true),
        (WeatherParameter.humidity, 60.0, 70.0, false),
        (WeatherParameter.windSpeed, 10.0, 5.0, true),
        (WeatherParameter.windSpeed, 10.0, 15.0, false),
        (WeatherParameter.windDirection, 180.0, 160.0, true),
        (WeatherParameter.windDirection, 180.0, 200.0, false)
    ])
    func belowCondition(_ parameter: WeatherParameter, _ threshold: Double, _ currentValue: Double, _ expected: Bool) throws {
        let pattern = HealthPattern.createStub(
            condition: .below,
            value: WeatherMeasurement.createStub(parameter: parameter, value: threshold)
        )
        let measurement = WeatherMeasurement.createStub(parameter: parameter, value: currentValue)
        
        let result = HealthPatternCalculator.calculate(pattern: pattern, currentValue: measurement)
        
        #expect(result == expected)
    }
    
    // MARK: - Tests - Equals Condition
    
    @Test(arguments: [
        (WeatherParameter.temperature, 25.0, 25.0, true),
        (WeatherParameter.temperature, 25.0, 25.05, true),      // Within tolerance (0.1)
        (WeatherParameter.temperature, 25.0, 25.15, false),     // Outside tolerance
        (WeatherParameter.temperature, 25.0, 24.95, true),      // Within tolerance
        (WeatherParameter.temperature, 25.0, 24.85, false),     // Outside tolerance
        (WeatherParameter.pressure, 1013.0, 1013.0, true),      // Exact match
        (WeatherParameter.pressure, 1013.0, 1013.05, true),     // Within tolerance (0.1)
        (WeatherParameter.pressure, 1013.0, 1013.15, false),    // Outside tolerance
        (WeatherParameter.humidity, 60.0, 60.0, true),          // Exact match
        (WeatherParameter.humidity, 60.0, 60.05, true),         // Within tolerance (0.1)
        (WeatherParameter.humidity, 60.0, 60.15, false),        // Outside tolerance
        (WeatherParameter.windSpeed, 10.0, 10.0, true),         // Exact match
        (WeatherParameter.windSpeed, 10.0, 10.05, true),        // Within tolerance (0.1)
        (WeatherParameter.windSpeed, 10.0, 10.15, false),       // Outside tolerance
        (WeatherParameter.windDirection, 180.0, 180.0, true),   // Exact match
        (WeatherParameter.windDirection, 180.0, 180.5, true),   // Within tolerance (1.0)
        (WeatherParameter.windDirection, 180.0, 181.5, false)   // Outside tolerance
    ])
    func equalsCondition(_ parameter: WeatherParameter, _ threshold: Double, _ currentValue: Double, _ expected: Bool) throws {
        let pattern = HealthPattern.createStub(
            condition: .equals,
            value: WeatherMeasurement.createStub(parameter: parameter, value: threshold)
        )
        let measurement = WeatherMeasurement.createStub(parameter: parameter, value: currentValue)
        
        let result = HealthPatternCalculator.calculate(pattern: pattern, currentValue: measurement)
        
        #expect(result == expected)
    }
    
    // MARK: - Tests - Rapid Increase
    
    @Test(arguments: [
        (WeatherParameter.temperature, 5.0, 20.0, 25.0, true),    // Increase >= threshold
        (WeatherParameter.temperature, 5.0, 20.0, 24.0, false),   // Increase < threshold
        (WeatherParameter.temperature, 5.0, 20.0, 20.0, false),   // No increase
        (WeatherParameter.pressure, 10.0, 1010.0, 1020.0, true),  // Increase >= threshold
        (WeatherParameter.pressure, 10.0, 1010.0, 1015.0, false), // Increase < threshold
        (WeatherParameter.humidity, 15.0, 50.0, 65.0, true),      // Increase >= threshold
        (WeatherParameter.humidity, 15.0, 50.0, 60.0, false),     // Increase < threshold
        (WeatherParameter.windSpeed, 8.0, 5.0, 13.0, true),       // Increase >= threshold
        (WeatherParameter.windSpeed, 8.0, 5.0, 10.0, false),      // Increase < threshold
        (WeatherParameter.windDirection, 20.0, 180.0, 200.0, true), // Increase >= threshold
        (WeatherParameter.windDirection, 20.0, 180.0, 195.0, false) // Increase < threshold
    ])
    func rapidIncrease(_ parameter: WeatherParameter, _ threshold: Double, _ previousValue: Double, _ currentValue: Double, _ expected: Bool) throws {
        let pattern = HealthPattern.createStub(
            condition: .rapidIncrease,
            value: WeatherMeasurement.createStub(parameter: parameter, value: threshold)
        )
        let currentMeasurement = WeatherMeasurement.createStub(parameter: parameter, value: currentValue)
        let previousMeasurement = WeatherMeasurement.createStub(parameter: parameter, value: previousValue)
        
        let result = HealthPatternCalculator.calculate(pattern: pattern, currentValue: currentMeasurement, previousValue: previousMeasurement)
        
        #expect(result == expected)
    }

    @Test func rapidIncreaseWithoutPreviousValue() throws {
        let pattern = HealthPattern.createStub(
            condition: .rapidIncrease,
            value: WeatherMeasurement.createStub(parameter: .temperature, value: 5.0)
        )
        let measurement = WeatherMeasurement.createStub(parameter: .temperature, value: 25.0)
        
        let result = HealthPatternCalculator.calculate(pattern: pattern, currentValue: measurement, previousValue: nil)
        
        #expect(result == false)
    }

    @Test func rapidIncreaseWithDifferentParameterType() throws {
        let pattern = HealthPattern.createStub(
            condition: .rapidIncrease,
            value: WeatherMeasurement.createStub(parameter: .temperature, value: 5.0)
        )
        let currentMeasurement = WeatherMeasurement.createStub(parameter: .temperature, value: 25.0)
        let previousMeasurement = WeatherMeasurement.createStub(parameter: .pressure, value: 1010.0) // Different parameter
        
        let result = HealthPatternCalculator.calculate(pattern: pattern, currentValue: currentMeasurement, previousValue: previousMeasurement)
        
        #expect(result == false)
    }

    // MARK: - Tests - Rapid Decrease
    
    @Test(arguments: [
        (WeatherParameter.temperature, 5.0, 25.0, 20.0, true),      // Decrease >= threshold
        (WeatherParameter.temperature, 5.0, 25.0, 21.0, false),     // Decrease < threshold
        (WeatherParameter.temperature, 5.0, 25.0, 25.0, false),     // No decrease
        (WeatherParameter.pressure, 10.0, 1020.0, 1010.0, true),    // Decrease >= threshold
        (WeatherParameter.pressure, 10.0, 1020.0, 1015.0, false),   // Decrease < threshold
        (WeatherParameter.humidity, 15.0, 65.0, 50.0, true),        // Decrease >= threshold
        (WeatherParameter.humidity, 15.0, 65.0, 55.0, false),       // Decrease < threshold
        (WeatherParameter.windSpeed, 8.0, 13.0, 5.0, true),         // Decrease >= threshold
        (WeatherParameter.windSpeed, 8.0, 13.0, 8.0, false),        // Decrease < threshold
        (WeatherParameter.windDirection, 20.0, 200.0, 180.0, true), // Decrease >= threshold
        (WeatherParameter.windDirection, 20.0, 200.0, 185.0, false) // Decrease < threshold
    ])
    func rapidDecrease(_ parameter: WeatherParameter, _ threshold: Double, _ previousValue: Double, _ currentValue: Double, _ expected: Bool) throws {
        let pattern = HealthPattern.createStub(
            condition: .rapidDecrease,
            value: WeatherMeasurement.createStub(parameter: parameter, value: threshold)
        )
        let currentMeasurement = WeatherMeasurement.createStub(parameter: parameter, value: currentValue)
        let previousMeasurement = WeatherMeasurement.createStub(parameter: parameter, value: previousValue)
        
        let result = HealthPatternCalculator.calculate(pattern: pattern, currentValue: currentMeasurement, previousValue: previousMeasurement)
        
        #expect(result == expected)
    }

    @Test func rapidDecreaseWithoutPreviousValue() throws {
        let pattern = HealthPattern.createStub(
            condition: .rapidDecrease,
            value: WeatherMeasurement.createStub(parameter: .temperature, value: 5.0)
        )
        let measurement = WeatherMeasurement.createStub(parameter: .temperature, value: 20.0)
        
        let result = HealthPatternCalculator.calculate(pattern: pattern, currentValue: measurement, previousValue: nil)
        
        #expect(result == false)
    }

    @Test func rapidDecreaseWithDifferentParameterType() throws {
        let pattern = HealthPattern.createStub(
            condition: .rapidDecrease,
            value: WeatherMeasurement.createStub(parameter: .temperature, value: 5.0)
        )
        let currentMeasurement = WeatherMeasurement.createStub(parameter: .temperature, value: 20.0)
        let previousMeasurement = WeatherMeasurement.createStub(parameter: .pressure, value: 1010.0) // Different parameter
        
        let result = HealthPatternCalculator.calculate(pattern: pattern, currentValue: currentMeasurement, previousValue: previousMeasurement)
        
        #expect(result == false)
    }
    
    // MARK: - Tests - Weather Condition
    
    @Test(arguments: [
        (WeatherCondition.sunny, WeatherCondition.sunny, true),
        (WeatherCondition.rainy, WeatherCondition.rainy, true),
        (WeatherCondition.cloudy, WeatherCondition.cloudy, true),
        (WeatherCondition.sunny, WeatherCondition.rainy, false),
        (WeatherCondition.rainy, WeatherCondition.cloudy, false)
    ])
    func weatherConditionEquals(_ patternCondition: WeatherCondition, _ currentCondition: WeatherCondition, _ expected: Bool) throws {
        let pattern = HealthPattern.createStub(
            condition: .equals,
            value: WeatherMeasurement.createStub(parameter: .weatherCondition, value: Double(patternCondition.rawValue))
        )
        let measurement = WeatherMeasurement.createStub(parameter: .weatherCondition, value: Double(currentCondition.rawValue))
        
        let result = HealthPatternCalculator.calculate(pattern: pattern, currentValue: measurement)
        
        #expect(result == expected)
    }
} 