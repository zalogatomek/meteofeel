import Foundation

public struct Weather: Equatable, Codable {
    public let condition: WeatherCondition
    public let temperature: Measurement<UnitTemperature>
    public let pressure: Measurement<UnitPressure>
    public let humidity: Double // Percentage
    public let windSpeed: Measurement<UnitSpeed>
    public let windDirection: Measurement<UnitAngle>
    public let timePeriod: TimePeriod
    public let fetchedAt: Date

    // NOTE: The current Weather model covers most health-related triggers. If data becomes available from the weather service, consider adding:
    // - pollenCount: Int?
    // - airQualityIndex: Int?
    // - sunlightHours: Double?
    
    public init(
        condition: WeatherCondition,
        temperature: Measurement<UnitTemperature>,
        pressure: Measurement<UnitPressure>,
        humidity: Double,
        windSpeed: Measurement<UnitSpeed>,
        windDirection: Measurement<UnitAngle>,
        timePeriod: TimePeriod,
        fetchedAt: Date = Date()
    ) {
        self.condition = condition
        self.temperature = temperature
        self.pressure = pressure
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.timePeriod = timePeriod
        self.fetchedAt = fetchedAt
    }
}