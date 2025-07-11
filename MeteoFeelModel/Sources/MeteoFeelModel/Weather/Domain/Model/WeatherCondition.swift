import Foundation

public enum WeatherCondition: Int, Codable, Equatable, Sendable {
    case sunny = 0
    case partlyCloudy
    case cloudy
    case rainy
    case heavyRain
    case snowy
    case foggy
    case windy
    case thunderstorm
    case unknown = -1

    init(value: Double) {
        self = WeatherCondition(rawValue: Int(value)) ?? .unknown
    }
} 