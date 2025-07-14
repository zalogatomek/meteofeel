import MeteoFeelModel
import SwiftUI

struct WeatherMeasurementView: View {

    // MARK: - Style

    enum Style {
        case regular
        case small

        var iconFont: Font {
            switch self {
            case .regular: .title2
            case .small: .caption
            }
        }

        var valueFont: Font {
            switch self {
            case .regular: .caption
            case .small: .caption
            }
        }

        var showsLabel: Bool {
            switch self {
            case .regular: true
            case .small: false
            }
        }
    }
    
    // MARK: - Properties
    
    private let measurement: WeatherMeasurement?
    private let style: Style
    
    // MARK: - Lifecycle
    
    init(measurement: WeatherMeasurement?, style: Style = .regular) {
        self.measurement = measurement
        self.style = style
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: measurement?.systemIconName ?? "questionmark.circle")
                .font(style.iconFont)
                .foregroundColor(.primary)
            
            Text(measurement?.formattedValue ?? String.placeholder(length: 5))
                .font(style.valueFont)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            if style.showsLabel {
                Text(measurement?.displayName ?? String.placeholder(length: 8))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .redacted(measurement == nil)
        .frame(maxWidth: .infinity)
    }
}

#Preview("Regular Style") {
    HStack(spacing: 16) {
        WeatherMeasurementView(
            measurement: WeatherMeasurement(parameter: .temperature, value: 22.0)
        )
        
        WeatherMeasurementView(
            measurement: WeatherMeasurement(parameter: .humidity, value: 65.0)
        )
        
        WeatherMeasurementView(
            measurement: WeatherMeasurement(parameter: .pressure, value: 1013.0),
        )
        
        WeatherMeasurementView(
            measurement: WeatherMeasurement(parameter: .windSpeed, value: 12.0),
        )
    }
    .padding()
}

#Preview("Small Style") {
    HStack(spacing: 16) {
        WeatherMeasurementView(
            measurement: WeatherMeasurement(parameter: .temperature, value: 22.0),
            style: .small
        )
        
        WeatherMeasurementView(
            measurement: WeatherMeasurement(parameter: .humidity, value: 65.0),
            style: .small
        )
        
        WeatherMeasurementView(
            measurement: WeatherMeasurement(parameter: .pressure, value: 1013.0),
            style: .small
        )
        
        WeatherMeasurementView(
            measurement: WeatherMeasurement(parameter: .windSpeed, value: 12.0),
            style: .small
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
