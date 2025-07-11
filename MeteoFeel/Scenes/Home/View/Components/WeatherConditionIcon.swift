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
        let colors = condition?.colors ?? WeatherCondition.unknown.colors
        let iconName = condition?.systemIconName ?? "questionmark"
        let renderingMode = condition?.symbolRenderingMode ?? .hierarchical

        Image(systemName: iconName)
            .symbolRenderingMode(renderingMode)
            .font(.system(size: size))
            .foregroundStyle(colors.0, colors.1)
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
