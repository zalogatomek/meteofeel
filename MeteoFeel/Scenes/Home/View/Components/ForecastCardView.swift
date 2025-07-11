import SwiftUI
import MeteoFeelModel

struct ForecastCardView: View {
    
    // MARK: - Properties
    
    let time: String
    let weather: String
    let temp: String
    let healthStatus: String
    let severity: AlertSeverity
    let weatherCondition: WeatherCondition
    let healthIconName: String
    
    // MARK: - Initialization
    
    init(
        time: String,
        weather: String,
        temp: String,
        healthStatus: String,
        severity: AlertSeverity,
        weatherCondition: WeatherCondition,
        healthIconName: String
    ) {
        self.time = time
        self.weather = weather
        self.temp = temp
        self.healthStatus = healthStatus
        self.severity = severity
        self.weatherCondition = weatherCondition
        self.healthIconName = healthIconName
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(time)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                WeatherConditionIcon(condition: weatherCondition, size: 24)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(weather)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Text(temp)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            
            HStack(alignment: .center, spacing: 8) {
                Image(systemName: healthIconName)
                    .font(.system(size: 16))
                    .foregroundColor(severityColor)
                
                Text(healthStatus)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(severityColor.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Private Properties
    
    private var severityColor: Color {
        switch severity {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

// MARK: - Alert Severity

enum AlertSeverity {
    case low
    case medium
    case high
}

#Preview {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 16) {
            ForecastCardView(
                time: "Morning",
                weather: "Partly Cloudy",
                temp: "26°C",
                healthStatus: "High temperature may affect your condition",
                severity: .high,
                weatherCondition: .partlyCloudy,
                healthIconName: "thermometer.high"
            )
            
            ForecastCardView(
                time: "Afternoon",
                weather: "Thunderstorm",
                temp: "22°C",
                healthStatus: "High risk of headaches due to pressure changes",
                severity: .high,
                weatherCondition: .thunderstorm,
                healthIconName: "exclamationmark.triangle.fill"
            )
        }
        .padding()
    }
} 