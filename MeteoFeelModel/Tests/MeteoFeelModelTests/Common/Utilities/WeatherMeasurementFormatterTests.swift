import Foundation
import Testing
@testable import MeteoFeelModel

struct WeatherMeasurementFormatterTests {

    // MARK: - Tests - Temperature Formatting
    
    @Test(arguments: [
        (-5.0, Locale(identifier: "en_US"), "23°"),  // US converts to Fahrenheit
        (-5.0, Locale(identifier: "en_GB"), "-5°C"), // British keeps Celsius with unit
        (-5.0, Locale(identifier: "pl_PL"), "-5°"),  // Polish keeps Celsius
        (-5.0, Locale(identifier: "nl_NL"), "-5°"),  // Dutch keeps Celsius
        (0.0, Locale(identifier: "en_US"), "32°"),   // US converts to Fahrenheit
        (0.0, Locale(identifier: "en_GB"), "0°C"),   // British keeps Celsius with unit
        (0.0, Locale(identifier: "pl_PL"), "0°"),    // Polish keeps Celsius
        (0.0, Locale(identifier: "nl_NL"), "0°"),    // Dutch keeps Celsius
        (25.0, Locale(identifier: "en_US"), "77°"),  // US converts to Fahrenheit
        (25.0, Locale(identifier: "en_GB"), "25°C"), // British keeps Celsius with unit
        (25.0, Locale(identifier: "pl_PL"), "25°"),  // Polish keeps Celsius
        (25.0, Locale(identifier: "nl_NL"), "25°"),  // Dutch keeps Celsius
        (25.4, Locale(identifier: "en_US"), "78°"),  // Rounds down, US converts
        (25.4, Locale(identifier: "en_GB"), "25°C"), // Rounds down, British keeps Celsius with unit
        (25.4, Locale(identifier: "pl_PL"), "25°"),  // Rounds down, Polish keeps Celsius
        (25.4, Locale(identifier: "nl_NL"), "25°"),  // Rounds down, Dutch keeps Celsius
        (25.7, Locale(identifier: "en_US"), "78°"),  // Rounds up, US converts
        (25.7, Locale(identifier: "en_GB"), "26°C"), // Rounds up, British keeps Celsius with unit
        (25.7, Locale(identifier: "pl_PL"), "26°"),  // Rounds up, Polish keeps Celsius
        (25.7, Locale(identifier: "nl_NL"), "26°")   // Rounds up, Dutch keeps Celsius
    ])
    func formatTemperature(_ value: Double, _ locale: Locale, _ expected: String) throws {
        let result = WeatherMeasurementFormatter.formatTemperature(value, locale: locale)
        
        #expect(result == expected)
    }
    
    // MARK: - Tests - Pressure Formatting
    
    @Test(arguments: [
        (950.0, Locale(identifier: "en_US"), "28″ Hg"),     // US uses inches of mercury
        (950.0, Locale(identifier: "en_GB"), "950mb"),      // British uses millibars without comma separator
        (950.0, Locale(identifier: "pl_PL"), "950 hPa"),    // Polish keeps metric
        (950.0, Locale(identifier: "nl_NL"), "950 hPa"),    // Dutch keeps metric without decimal
        (1000.0, Locale(identifier: "en_US"), "30″ Hg"),    // US uses inches of mercury
        (1000.0, Locale(identifier: "en_GB"), "1,000mb"),   // British uses millibars with comma separator
        (1000.0, Locale(identifier: "pl_PL"), "1000 hPa"),  // Polish keeps metric
        (1000.0, Locale(identifier: "nl_NL"), "1.000 hPa"), // Dutch uses decimal separator
        (1013.0, Locale(identifier: "en_US"), "30″ Hg"),    // US uses inches of mercury
        (1013.0, Locale(identifier: "en_GB"), "1,013mb"),   // British uses millibars with comma separator
        (1013.0, Locale(identifier: "pl_PL"), "1013 hPa"),  // Polish keeps metric
        (1013.0, Locale(identifier: "nl_NL"), "1.013 hPa"), // Dutch uses decimal separator
        (1013.4, Locale(identifier: "en_US"), "30″ Hg"),    // Rounds down, US uses inches
        (1013.4, Locale(identifier: "en_GB"), "1,013mb"),   // Rounds down, British uses millibars with comma separator
        (1013.4, Locale(identifier: "pl_PL"), "1013 hPa"),  // Rounds down, Polish keeps metric
        (1013.4, Locale(identifier: "nl_NL"), "1.013 hPa"), // Rounds down, Dutch uses decimal separator
        (1013.7, Locale(identifier: "en_US"), "30″ Hg"),    // Rounds up, US uses inches
        (1013.7, Locale(identifier: "en_GB"), "1,014mb"),   // Rounds up, British uses millibars with comma separator
        (1013.7, Locale(identifier: "pl_PL"), "1014 hPa"),  // Rounds up, Polish keeps metric
        (1013.7, Locale(identifier: "nl_NL"), "1.014 hPa"), // Rounds up, Dutch uses decimal separator
    ])
    func formatPressure(_ value: Double, _ locale: Locale, _ expected: String) throws {
        let result = WeatherMeasurementFormatter.formatPressure(value, locale: locale)
        
        #expect(result == expected)
    }
    
    // MARK: - Tests - Humidity Formatting
    
    @Test(arguments: [
        (0.0, Locale(identifier: "en_US"), "0%"),
        (0.0, Locale(identifier: "en_GB"), "0%"),
        (0.0, Locale(identifier: "pl_PL"), "0%"),
        (0.0, Locale(identifier: "nl_NL"), "0%"),
        (60.0, Locale(identifier: "en_US"), "60%"),
        (60.0, Locale(identifier: "en_GB"), "60%"),
        (60.0, Locale(identifier: "pl_PL"), "60%"),
        (60.0, Locale(identifier: "nl_NL"), "60%"),
        (60.4, Locale(identifier: "en_US"), "60%"),  // Rounds down
        (60.4, Locale(identifier: "en_GB"), "60%"),  // Rounds down
        (60.4, Locale(identifier: "pl_PL"), "60%"),  // Rounds down
        (60.4, Locale(identifier: "nl_NL"), "60%"),  // Rounds down
        (60.7, Locale(identifier: "en_US"), "61%"),  // Rounds up
        (60.7, Locale(identifier: "en_GB"), "61%"),  // Rounds up
        (60.7, Locale(identifier: "pl_PL"), "61%"),  // Rounds up
        (60.7, Locale(identifier: "nl_NL"), "61%"),  // Rounds up
        (100.0, Locale(identifier: "en_US"), "100%"),
        (100.0, Locale(identifier: "en_GB"), "100%"),
        (100.0, Locale(identifier: "pl_PL"), "100%"),
        (100.0, Locale(identifier: "nl_NL"), "100%")
    ])
    func formatHumidity(_ value: Double, _ locale: Locale, _ expected: String) throws {
        let result = WeatherMeasurementFormatter.formatHumidity(value, locale: locale)
        
        #expect(result == expected)
    }
    
    // MARK: - Tests - Wind Speed Formatting
    
    @Test(arguments: [
        (10.0, Locale(identifier: "en_US"), "6mph"),      // US converts to miles per hour
        (10.0, Locale(identifier: "en_GB"), "6mph"),      // British converts to miles per hour
        (10.0, Locale(identifier: "pl_PL"), "10 km/h"),   // Polish keeps metric
        (10.0, Locale(identifier: "nl_NL"), "10 km/u"),   // Dutch uses "km/u" abbreviation
        (0.0, Locale(identifier: "en_US"), "0mph"),       // US converts to miles per hour
        (0.0, Locale(identifier: "en_GB"), "0mph"),       // British converts to miles per hour
        (0.0, Locale(identifier: "pl_PL"), "0 km/h"),     // Polish keeps metric
        (0.0, Locale(identifier: "nl_NL"), "0 km/u"),     // Dutch uses "km/u" abbreviation
        (25.0, Locale(identifier: "en_US"), "16mph"),     // US converts to miles per hour
        (25.0, Locale(identifier: "en_GB"), "16mph"),     // British converts to miles per hour
        (25.0, Locale(identifier: "pl_PL"), "25 km/h"),   // Polish keeps metric
        (25.0, Locale(identifier: "nl_NL"), "25 km/u"),   // Dutch uses "km/u" abbreviation
        (10.7, Locale(identifier: "en_US"), "7mph"),      // Rounds up, US converts
        (10.7, Locale(identifier: "en_GB"), "7mph"),      // Rounds up, British converts
        (10.7, Locale(identifier: "pl_PL"), "11 km/h"),   // Rounds up, Polish keeps metric
        (10.7, Locale(identifier: "nl_NL"), "11 km/u"),   // Rounds up, Dutch uses "km/u"
        (10.4, Locale(identifier: "en_US"), "6mph"),      // Rounds down, US converts
        (10.4, Locale(identifier: "en_GB"), "6mph"),      // Rounds down, British converts
        (10.4, Locale(identifier: "pl_PL"), "10 km/h"),   // Rounds down, Polish keeps metric
        (10.4, Locale(identifier: "nl_NL"), "10 km/u"),   // Rounds down, Dutch uses "km/u"
        (5.0, Locale(identifier: "en_US"), "3mph"),       // US converts to miles per hour
        (5.0, Locale(identifier: "en_GB"), "3mph"),       // British converts to miles per hour
        (5.0, Locale(identifier: "pl_PL"), "5 km/h"),     // Polish keeps metric
        (5.0, Locale(identifier: "nl_NL"), "5 km/u"),     // Dutch uses "km/u" abbreviation
        (50.0, Locale(identifier: "en_US"), "31mph"),     // US converts to miles per hour
        (50.0, Locale(identifier: "en_GB"), "31mph"),     // British converts to miles per hour
        (50.0, Locale(identifier: "pl_PL"), "50 km/h"),   // Polish keeps metric
        (50.0, Locale(identifier: "nl_NL"), "50 km/u")    // Dutch uses "km/u" abbreviation
    ])
    func formatWindSpeed(_ value: Double, _ locale: Locale, _ expected: String) throws {
        let result = WeatherMeasurementFormatter.formatWindSpeed(value, locale: locale)
        
        #expect(result == expected)
    }
    
    // MARK: - Tests - Wind Direction Formatting
    
    @Test(arguments: [
        (0.0, Locale(identifier: "en_US"), "0°"),
        (0.0, Locale(identifier: "en_GB"), "0°"),
        (0.0, Locale(identifier: "pl_PL"), "0°"),
        (0.0, Locale(identifier: "nl_NL"), "0°"),
        (180.0, Locale(identifier: "en_US"), "180°"),
        (180.0, Locale(identifier: "en_GB"), "180°"),
        (180.0, Locale(identifier: "pl_PL"), "180°"),
        (180.0, Locale(identifier: "nl_NL"), "180°"),
        (180.4, Locale(identifier: "en_US"), "180°"),  // Rounds down
        (180.4, Locale(identifier: "en_GB"), "180°"),  // Rounds down
        (180.4, Locale(identifier: "pl_PL"), "180°"),  // Rounds down
        (180.4, Locale(identifier: "nl_NL"), "180°"),  // Rounds down
        (180.7, Locale(identifier: "en_US"), "181°"),  // Rounds up
        (180.7, Locale(identifier: "en_GB"), "181°"),  // Rounds up
        (180.7, Locale(identifier: "pl_PL"), "181°"),  // Rounds up
        (180.7, Locale(identifier: "nl_NL"), "181°"),  // Rounds up
        (360.0, Locale(identifier: "en_US"), "360°"),
        (360.0, Locale(identifier: "en_GB"), "360°"),
        (360.0, Locale(identifier: "pl_PL"), "360°"),
        (360.0, Locale(identifier: "nl_NL"), "360°")
    ])
    func formatWindDirection(_ value: Double, _ locale: Locale, _ expected: String) throws {
        let result = WeatherMeasurementFormatter.formatWindDirection(value, locale: locale)
        
        #expect(result == expected)
    }
    

    
    // MARK: - Tests - Generic Format Method
    
    @Test(arguments: [
        (WeatherMeasurement.createStub(parameter: .temperature, value: 25.0), Locale(identifier: "en_US"), "77°"),
        (WeatherMeasurement.createStub(parameter: .temperature, value: 25.0), Locale(identifier: "en_GB"), "25°C"),
        (WeatherMeasurement.createStub(parameter: .temperature, value: 25.0), Locale(identifier: "pl_PL"), "25°"),
        (WeatherMeasurement.createStub(parameter: .temperature, value: 25.0), Locale(identifier: "nl_NL"), "25°"),
        (WeatherMeasurement.createStub(parameter: .pressure, value: 1013.0), Locale(identifier: "en_US"), "30″ Hg"),
        (WeatherMeasurement.createStub(parameter: .pressure, value: 1013.0), Locale(identifier: "en_GB"), "1,013mb"),
        (WeatherMeasurement.createStub(parameter: .pressure, value: 1013.0), Locale(identifier: "pl_PL"), "1013 hPa"),
        (WeatherMeasurement.createStub(parameter: .pressure, value: 1013.0), Locale(identifier: "nl_NL"), "1.013 hPa"),
        (WeatherMeasurement.createStub(parameter: .humidity, value: 60.0), Locale(identifier: "en_US"), "60%"),
        (WeatherMeasurement.createStub(parameter: .humidity, value: 60.0), Locale(identifier: "en_GB"), "60%"),
        (WeatherMeasurement.createStub(parameter: .humidity, value: 60.0), Locale(identifier: "pl_PL"), "60%"),
        (WeatherMeasurement.createStub(parameter: .humidity, value: 60.0), Locale(identifier: "nl_NL"), "60%"),
        (WeatherMeasurement.createStub(parameter: .windSpeed, value: 10.0), Locale(identifier: "en_US"), "6mph"),
        (WeatherMeasurement.createStub(parameter: .windSpeed, value: 10.0), Locale(identifier: "en_GB"), "6mph"),
        (WeatherMeasurement.createStub(parameter: .windSpeed, value: 10.0), Locale(identifier: "pl_PL"), "10 km/h"),
        (WeatherMeasurement.createStub(parameter: .windSpeed, value: 10.0), Locale(identifier: "nl_NL"), "10 km/u"),
        (WeatherMeasurement.createStub(parameter: .windDirection, value: 180.0), Locale(identifier: "en_US"), "180°"),
        (WeatherMeasurement.createStub(parameter: .windDirection, value: 180.0), Locale(identifier: "en_GB"), "180°"),
        (WeatherMeasurement.createStub(parameter: .windDirection, value: 180.0), Locale(identifier: "pl_PL"), "180°"),
        (WeatherMeasurement.createStub(parameter: .windDirection, value: 180.0), Locale(identifier: "nl_NL"), "180°")
    ])
    func format(_ measurement: WeatherMeasurement, _ locale: Locale, _ expected: String) throws {
        let result = WeatherMeasurementFormatter.format(measurement, locale: locale)
        
        #expect(result == expected)
    }
} 
