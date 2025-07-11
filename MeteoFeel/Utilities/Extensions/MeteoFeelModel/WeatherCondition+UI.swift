import SwiftUI
import MeteoFeelModel

extension WeatherCondition {
    
    var displayName: String {
        switch self {
        case .sunny: "Sunny"
        case .partlyCloudy: "Partly Cloudy"
        case .cloudy: "Cloudy"
        case .rainy: "Light Rain"
        case .heavyRain: "Heavy Rain"
        case .snowy: "Snow"
        case .foggy: "Foggy"
        case .windy: "Windy"
        case .thunderstorm: "Thunderstorm"
        case .unknown: "Unknown"
        }
    }
    
    var systemIconName: String {
        switch self {
        case .sunny: "sun.max.fill"
        case .partlyCloudy: "cloud.sun.fill"
        case .cloudy: "cloud.fill"
        case .rainy: "cloud.drizzle.fill"
        case .heavyRain: "cloud.rain.fill"
        case .snowy: "cloud.snow.fill"
        case .foggy: "cloud.fog.fill"
        case .windy: "wind"
        case .thunderstorm: "cloud.bolt.fill"
        case .unknown: "questionmark"
        }
    }
    
    var symbolRenderingMode: SymbolRenderingMode {
        switch self {
        case .sunny, .cloudy, .foggy, .windy, .unknown:
            .hierarchical
        default:
            .palette
        }
    }
    
    var colors: (Color, Color) {
        switch self {
        case .sunny: (.sun, .sun)
        case .partlyCloudy: (.cloud, .sun)
        case .cloudy: (.cloud, .cloud)
        case .rainy: (.cloud, .lightRain)
        case .heavyRain: (.cloud, .heavyRain)
        case .snowy: (.cloud, .snow)
        case .foggy: (.cloud, .cloud)
        case .windy: (.wind, .wind)
        case .thunderstorm: (.cloud, .lightning)
        case .unknown: (.cloud, .cloud)
        }
    }
} 
