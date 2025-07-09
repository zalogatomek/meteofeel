import SwiftUI

struct WeatherMetricView: View {
    
    // MARK: - Properties
    
    let iconName: String
    let value: String?
    let label: String
    let iconColor: Color
    
    // MARK: - Initialization
    
    init(
        iconName: String,
        value: String?,
        label: String,
        iconColor: Color = .primary
    ) {
        self.iconName = iconName
        self.value = value
        self.label = label
        self.iconColor = iconColor
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(iconColor)
            
            Text(value ?? String.placeholder(length: 5))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .redacted(value == nil)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview("With Data") {
    HStack(spacing: 16) {
        WeatherMetricView(
            iconName: "sun.max.fill",
            value: "Sunny",
            label: "Weather",
            iconColor: .yellow
        )
        
        WeatherMetricView(
            iconName: "thermometer",
            value: "22°C",
            label: "Temperature"
        )
        
        WeatherMetricView(
            iconName: "humidity",
            value: "65%",
            label: "Humidity"
        )
    }
    .padding()
}

#Preview("Loading State") {
    HStack(spacing: 16) {
        WeatherMetricView(
            iconName: "sun.max.fill",
            value: nil,
            label: "Weather",
            iconColor: .yellow
        )
        
        WeatherMetricView(
            iconName: "thermometer",
            value: nil,
            label: "Temperature"
        )
        
        WeatherMetricView(
            iconName: "humidity",
            value: nil,
            label: "Humidity"
        )
    }
    .padding()
} 