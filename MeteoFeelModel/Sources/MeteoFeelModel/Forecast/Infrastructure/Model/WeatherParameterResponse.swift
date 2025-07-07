import Foundation

enum WeatherParameterResponse: String, EnumerationResponse {
    case temperature
    case pressure
    case humidity
    case windSpeed
    case windDirection
    case weatherCondition
    case unknown
    
    static var defaultCase: Self { .unknown }
} 