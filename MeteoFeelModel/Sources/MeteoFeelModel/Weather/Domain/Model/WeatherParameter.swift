import Foundation

public enum WeatherParameter: String, Codable, Equatable, CaseIterable, Sendable {
    case temperature
    case pressure
    case humidity
    case windSpeed
    case windDirection
    case weatherCondition
} 