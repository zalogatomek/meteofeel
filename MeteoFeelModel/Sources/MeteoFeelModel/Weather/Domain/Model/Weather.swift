public import Foundation

public struct Weather: Equatable, Codable, Sendable {
    public let condition: WeatherCondition
    public let temperature: Double
    public let pressure: Double
    public let humidity: Double
    public let windSpeed: Double
    public let windDirection: Double
    public let timePeriod: TimePeriod
    public let fetchedAt: Date

    // NOTE: The current Weather model covers most health-related triggers. If data becomes available from the weather service, consider adding:
    // - pollenCount: Int?
    // - airQualityIndex: Int?
    // - sunlightHours: Double?
    
    public init(
        condition: WeatherCondition,
        temperature: Double,
        pressure: Double,
        humidity: Double,
        windSpeed: Double,
        windDirection: Double,
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

extension Weather {
    
    // MARK: - Stubs
    
    public static func createStub(
        condition: WeatherCondition = .sunny,
        temperature: Double = 25.0,
        pressure: Double = 1013.0,
        humidity: Double = 60.0,
        windSpeed: Double = 10.0,
        windDirection: Double = 180.0,
        timePeriod: TimePeriod = TimePeriod.createStub(),
        fetchedAt: Date = Date()
    ) -> Weather {
        Weather(
            condition: condition,
            temperature: temperature,
            pressure: pressure,
            humidity: humidity,
            windSpeed: windSpeed,
            windDirection: windDirection,
            timePeriod: timePeriod,
            fetchedAt: fetchedAt
        )
    }
}
