import Foundation

public enum WeatherCondition: String, Codable, Equatable, Sendable {
    case sunny
    case partlyCloudy
    case cloudy
    case rainy
    case heavyRain
    case snowy
    case foggy
    case windy
    case thunderstorm
    case unknown
} 