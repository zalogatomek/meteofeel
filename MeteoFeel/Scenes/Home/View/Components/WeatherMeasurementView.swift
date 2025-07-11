import SwiftUI
import MeteoFeelModel

struct WeatherMeasurementView: View {
    
    // MARK: - Properties
    
    let measurement: WeatherMeasurement?
    
    // MARK: - Initialization
    
    init(measurement: WeatherMeasurement?) {
        self.measurement = measurement
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: measurement?.systemIconName ?? "questionmark.circle")
                .font(.title2)
                .foregroundColor(.primary)
            
            Text(measurement?.formattedValue ?? String.placeholder(length: 5))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .redacted(measurement == nil)
            
            Text(measurement?.displayName ?? String.placeholder(length: 8))
                .font(.caption2)
                .foregroundColor(.secondary)
                .redacted(measurement == nil)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview("With Data") {
    HStack(spacing: 16) {
        WeatherMeasurementView(
            measurement: WeatherMeasurement(parameter: .weatherCondition, value: 1.0)
        )
        
        WeatherMeasurementView(
            measurement: WeatherMeasurement(parameter: .temperature, value: 22.0)
        )
        
        WeatherMeasurementView(
            measurement: WeatherMeasurement(parameter: .humidity, value: 65.0)
        )
    }
    .padding()
}

#Preview("Loading State") {
    HStack(spacing: 16) {
        WeatherMeasurementView(measurement: nil)
        WeatherMeasurementView(measurement: nil)
        WeatherMeasurementView(measurement: nil)
    }
    .padding()
} 
