import Foundation

public enum WeatherParameter: String, Codable, Equatable, CaseIterable {
    case temperature
    case pressure
    case humidity
    case windSpeed
    case windDirection
    case weatherType
} 