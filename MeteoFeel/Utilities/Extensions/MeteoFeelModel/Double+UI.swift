import Foundation
import MeteoFeelModel

extension Double {
    
    var formattedHumidity: String {
        WeatherMeasurementFormatter.formatHumidity(self)
    }
    
    var formattedTemperature: String {
        WeatherMeasurementFormatter.formatTemperature(self)
    }
    
    var formattedPressure: String {
        WeatherMeasurementFormatter.formatPressure(self)
    }
    
    var formattedWindSpeed: String {
        WeatherMeasurementFormatter.formatWindSpeed(self)
    }
    
    var formattedValue: String {
        // Default formatting - this should be overridden by specific parameter extensions
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
} 