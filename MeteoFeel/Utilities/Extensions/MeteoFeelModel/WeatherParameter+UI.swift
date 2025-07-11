import SwiftUI
import MeteoFeelModel

extension WeatherParameter {
    
    var displayName: String {
        switch self {
        case .temperature: "Temperature"
        case .pressure: "Pressure"
        case .humidity: "Humidity"
        case .windSpeed: "Wind Speed"
        case .windDirection: "Wind Direction"
        case .weatherCondition: "Weather Condition"
        }
    }
} 