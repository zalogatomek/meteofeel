import Foundation

public struct WeatherMeasurement: Codable, Equatable, Sendable {
    public let parameter: WeatherParameter
    public let value: Double

    public init(parameter: WeatherParameter, value: Double) {
        self.parameter = parameter
        self.value = value
    }
} 