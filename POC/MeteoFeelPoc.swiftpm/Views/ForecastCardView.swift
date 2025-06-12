import SwiftUI

struct ForecastCardView: View {
    // MARK: - Properties
    
    let time: String
    let weather: String
    let temp: String
    let healthStatus: String
    let severity: AlertSeverity
    let iconName: String
    
    // MARK: - Helpers
    
    private var weatherIcon: String {
        switch weather.lowercased() {
        case "sunny", "clear": "sun.max.fill"
        case "partly cloudy": "cloud.sun.fill"
        case "cloudy": "cloud.fill"
        case "rainy", "light rain": "cloud.drizzle.fill"
        case "heavy rain": "cloud.rain.fill"
        case "thunderstorm": "cloud.bolt.fill"
        case "snowy": "cloud.snow.fill"
        case "foggy", "misty": "cloud.fog.fill"
        default: "sun.max.fill"
        }
    }
    
    private var weatherIconStyle: SymbolRenderingMode {
        switch weather.lowercased() {
        case "sunny", "clear", "cloudy", "foggy", "misty": .hierarchical
        default: .palette
        }
    }
    
    // MARK: - View
    
    @ViewBuilder
    private var weatherIconView: some View {
        let image = Image(systemName: weatherIcon)
            .symbolRenderingMode(weatherIconStyle)
            .font(.system(size: 20))
        
        switch weather.lowercased() {
        case "sunny", "clear":
            image.foregroundStyle(.yellow)
        case "partly cloudy":
            image.foregroundStyle(Color.cloudColor, .yellow)
        case "cloudy":
            image.foregroundStyle(Color.cloudColor)
        case "rainy", "light rain":
            image.foregroundStyle(Color.cloudColor, Color.lightRainColor)
        case "heavy rain":
            image.foregroundStyle(Color.cloudColor, Color.heavyRainColor)
        case "thunderstorm":
            image.foregroundStyle(Color.cloudColor, .yellow)
        case "snowy":
            image.foregroundStyle(Color.cloudColor, Color.snowColor)
        case "foggy", "misty":
            image.foregroundStyle(Color.cloudColor)
        default:
            image.foregroundStyle(.yellow)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(time)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                HStack(spacing: 8) {
                    weatherIconView
                    Text(weather)
                        .font(.subheadline)
                }
            }
            
            Text(temp)
                .font(.title2.weight(.bold))
            
            Divider()
            
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: iconName)
                    .font(.system(size: 20))
                    .foregroundColor(severity.color)
                    .frame(width: 24, height: 24)
                
                Text(healthStatus)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.95))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
} 