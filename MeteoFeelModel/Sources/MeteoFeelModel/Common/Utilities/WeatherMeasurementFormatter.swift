public import Foundation

public struct WeatherMeasurementFormatter {
    
    // MARK: - Format
    
    public static func format(_ measurement: WeatherMeasurement, locale: Locale = .current) -> String {
        switch measurement.parameter {
        case .temperature:
            return formatTemperature(measurement.value, locale: locale)
        case .pressure:
            return formatPressure(measurement.value, locale: locale)
        case .humidity:
            return formatHumidity(measurement.value, locale: locale)
        case .windSpeed:
            return formatWindSpeed(measurement.value, locale: locale)
        case .windDirection:
            return formatWindDirection(measurement.value, locale: locale)
        case .weatherCondition:
            return formatWeatherCondition(measurement.value)
        }
    }
    
    public static func formatTemperature(_ value: Double, locale: Locale = .current) -> String {
        let measurement = Measurement(value: value, unit: UnitTemperature.celsius)
        let formatter = MeasurementFormatter()
        formatter.locale = locale
        formatter.unitStyle = .short
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter.string(from: measurement)
    }
    
    public static func formatPressure(_ value: Double, locale: Locale = .current) -> String {
        let measurement = Measurement(value: value, unit: UnitPressure.hectopascals)
        let formatter = MeasurementFormatter()
        formatter.locale = locale
        formatter.unitStyle = .short
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter.string(from: measurement)
    }
    
    public static func formatHumidity(_ value: Double, locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return "\(formatter.string(from: NSNumber(value: value)) ?? "\(Int(value))")%"
    }
    
    public static func formatWindSpeed(_ value: Double, locale: Locale = .current) -> String {
        let measurement = Measurement(value: value, unit: UnitSpeed.kilometersPerHour)
        let formatter = MeasurementFormatter()
        formatter.locale = locale
        formatter.unitStyle = .short
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter.string(from: measurement)
    }
    
    public static func formatWindDirection(_ value: Double, locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return "\(formatter.string(from: NSNumber(value: value)) ?? "\(Int(value))")°"
    }
    
    // Note: Weather condition formatting is not supported in formatter due to localization challenges.
    public static func formatWeatherCondition(_ value: Double) -> String {
        let condition = WeatherCondition(value: value)
        return "\(condition.rawValue)"
    }
} 
