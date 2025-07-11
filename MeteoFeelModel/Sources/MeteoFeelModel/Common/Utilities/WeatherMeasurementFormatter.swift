import Foundation

public struct WeatherMeasurementFormatter {
    
    // MARK: - Format
    
    public static func format(_ measurement: WeatherMeasurement) -> String {
        switch measurement.parameter {
        case .temperature:
            return formatTemperature(measurement.value)
        case .pressure:
            return formatPressure(measurement.value)
        case .humidity:
            return formatHumidity(measurement.value)
        case .windSpeed:
            return formatWindSpeed(measurement.value)
        case .windDirection:
            return formatWindDirection(measurement.value)
        case .weatherCondition:
            return formatWeatherCondition(measurement.value)
        }
    }
    
    public static func formatTemperature(_ value: Double) -> String {
        let measurement = Measurement(value: value, unit: UnitTemperature.celsius)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter.string(from: measurement)
    }
    
    public static func formatPressure(_ value: Double) -> String {
        let measurement = Measurement(value: value, unit: UnitPressure.hectopascals)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter.string(from: measurement)
    }
    
    public static func formatHumidity(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return "\(formatter.string(from: NSNumber(value: value)) ?? "\(Int(value))")%"
    }
    
    public static func formatWindSpeed(_ value: Double) -> String {
        let measurement = Measurement(value: value, unit: UnitSpeed.kilometersPerHour)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter.string(from: measurement)
    }
    
    public static func formatWindDirection(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return "\(formatter.string(from: NSNumber(value: value)) ?? "\(Int(value))")°"
    }
    
    public static func formatWeatherCondition(_ value: Double) -> String {
        let condition = WeatherCondition(value: value)
        return "\(condition.rawValue)"
    }
} 
