import Foundation

public struct WeatherMeasurement: Codable, Equatable, Sendable {

    // MARK: - Properties

    public let parameter: WeatherParameter
    public let value: Double

    // MARK: - Lifecycle

    public init(parameter: WeatherParameter, value: Double) {
        self.parameter = parameter
        self.value = value
    }
}

extension WeatherMeasurement {
    
    // MARK: - Stubs
    
    public static func createStub(
        parameter: WeatherParameter = .temperature,
        value: Double = 25.0
    ) -> WeatherMeasurement {
        WeatherMeasurement(
            parameter: parameter,
            value: value
        )
    }
} 