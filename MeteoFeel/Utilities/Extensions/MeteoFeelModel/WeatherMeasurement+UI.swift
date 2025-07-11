import SwiftUI
import MeteoFeelModel

extension WeatherMeasurement {

    var formattedValue: String {
        WeatherMeasurementFormatter.format(self)
    }
    
    var systemIconName: String {
        switch parameter {
        case .temperature: "thermometer"
        case .pressure: "gauge"
        case .humidity: "humidity"
        case .windSpeed: "wind"
        case .windDirection: "location.north"
        case .weatherCondition: WeatherCondition(rawValue: Int(value))?.systemIconName ?? "questionmark"
        }
    }
    
    var displayName: String {
        parameter.displayName
    }
} 