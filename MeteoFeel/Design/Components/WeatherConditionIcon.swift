import SwiftUI
import MeteoFeelModel

struct WeatherConditionIcon: View {
    
    // MARK: - Properties

    private let condition: WeatherCondition?
    private let size: CGFloat
    
    // MARK: - Lifecycle

    init(condition: WeatherCondition?, size: CGFloat = 32) {
        self.condition = condition
        self.size = size
    }
    
    // MARK: - View

    var body: some View {
        Image(systemName: iconName)
            .symbolRenderingMode(symbolRenderingMode)
            .font(.system(size: size))
            .foregroundStyle(style.0, style.1)
    }
    
    // MARK: - Helpers

    private var iconName: String {
        switch condition {
        case .sunny: "sun.max.fill"
        case .partlyCloudy: "cloud.sun.fill"
        case .cloudy: "cloud.fill"
        case .rainy: "cloud.drizzle.fill"
        case .heavyRain: "cloud.rain.fill"
        case .snowy: "cloud.snow.fill"
        case .foggy: "cloud.fog.fill"
        case .windy: "wind"
        case .thunderstorm: "cloud.bolt.fill"
        case .unknown, nil: "questionmark"
        }
    }
    
    private var symbolRenderingMode: SymbolRenderingMode {
        switch condition {
        case .sunny, .cloudy, .foggy, .windy, .unknown:
            .hierarchical
        default:
            .palette
        }
    }
    
    private var style: (Color, Color) {
        switch condition {
        case .sunny: (.sun, .sun)
        case .partlyCloudy: (.cloud, .sun)
        case .cloudy: (.cloud, .cloud)
        case .rainy: (.cloud, .lightRain)
        case .heavyRain: (.cloud, .heavyRain)
        case .snowy: (.cloud, .snow)
        case .foggy: (.cloud, .cloud)
        case .windy: (.wind, .wind)
        case .thunderstorm: (.cloud, .lightning)
        case .unknown, nil: (.cloud, .cloud)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 16) {
            WeatherConditionIcon(condition: .sunny)
            WeatherConditionIcon(condition: .partlyCloudy)
            WeatherConditionIcon(condition: .cloudy)
        }
        HStack(spacing: 16) {
            WeatherConditionIcon(condition: .rainy)
            WeatherConditionIcon(condition: .heavyRain)
            WeatherConditionIcon(condition: .snowy)
        }
        HStack(spacing: 16) {
            WeatherConditionIcon(condition: .foggy)
            WeatherConditionIcon(condition: .windy)
            WeatherConditionIcon(condition: .thunderstorm)
        }
    }
    .cardStyle()
} 
