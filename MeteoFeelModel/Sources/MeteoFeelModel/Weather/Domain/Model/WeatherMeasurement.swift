import Foundation

public struct WeatherMeasurement: Codable, Equatable, Sendable {
    public let parameter: WeatherParameter
    public let value: WeatherMeasurementValue
    
    public init(parameter: WeatherParameter, value: WeatherMeasurementValue) {
        self.parameter = parameter
        self.value = value
    }
}

public enum WeatherMeasurementValue: Codable, Equatable, Sendable {
    case temperature(Measurement<UnitTemperature>)
    case pressure(Measurement<UnitPressure>)
    case humidity(Double)
    case windSpeed(Measurement<UnitSpeed>)
    case windDirection(Measurement<UnitAngle>)
    case weatherCondition(WeatherCondition)
}