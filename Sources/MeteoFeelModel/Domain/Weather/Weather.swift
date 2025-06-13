import Foundation

public struct Weather: Equatable, Codable {
    public let type: WeatherType
    public let temperature: Measurement<UnitTemperature>
    public let pressure: Measurement<UnitPressure>
    public let humidity: Double // Percentage
    public let windSpeed: Measurement<UnitSpeed>
    public let windDirection: Measurement<UnitAngle>
    public let timePeriod: TimePeriod

    // NOTE: The current Weather model covers most health-related triggers. If data becomes available from the weather service, consider adding:
    // - pollenCount: Int?
    // - airQualityIndex: Int?
    // - sunlightHours: Double?
    
    public init(
        type: WeatherType,
        temperature: Measurement<UnitTemperature>,
        pressure: Measurement<UnitPressure>,
        humidity: Double,
        windSpeed: Measurement<UnitSpeed>,
        windDirection: Measurement<UnitAngle>,
        timePeriod: TimePeriod
    ) {
        self.type = type
        self.temperature = temperature
        self.pressure = pressure
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.timePeriod = timePeriod
    }
}