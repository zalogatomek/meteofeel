import Foundation

public enum WeatherParameter: String, Codable, Equatable, Comparable, CaseIterable, Sendable {
    case temperature
    case pressure
    case humidity
    case windSpeed
    case windDirection
    case weatherCondition

    // MARK: - Comparable
    
    public static func < (lhs: WeatherParameter, rhs: WeatherParameter) -> Bool {
        WeatherParameter.allCases.firstIndex(of: lhs) ?? .zero < WeatherParameter.allCases.firstIndex(of: rhs) ?? .zero
    }
} 