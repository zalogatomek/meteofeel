import Foundation

enum WeatherConditionResponse: String, Codable, EnumerationResponse {
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
    
    static var defaultCase: WeatherConditionResponse { .unknown }
} 