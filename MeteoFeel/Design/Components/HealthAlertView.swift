import SwiftUI
import MeteoFeelModel

struct HealthAlertView: View {
    
    // MARK: - Style
    
    enum Style {
        case regular
        case small
        
        var iconFont: Font {
            switch self {
            case .regular: .title3
            case .small: .caption
            }
        }
        
        var titleFont: Font {
            switch self {
            case .regular: .caption
            case .small: .caption
            }
        }
        
        var descriptionFont: Font {
            switch self {
            case .regular: .caption2
            case .small: .caption2
            }
        }
        
        var showsDescription: Bool {
            switch self {
            case .regular: true
            case .small: false
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .regular: 24
            case .small: 16
            }
        }
    }
    
    // MARK: - Properties
    
    private let alert: HealthAlert
    private let style: Style
    
    // MARK: - Lifecycle
    
    init(alert: HealthAlert, style: Style = .regular) {
        self.alert = alert
        self.style = style
    }
    
    // MARK: - View
    
    var body: some View {
        HStack(spacing: 8) {
            if alert.pattern.value.parameter == .weatherCondition {
                WeatherConditionIcon(
                    condition: WeatherCondition(rawValue: Int(alert.pattern.value.value)),
                    size: style.iconSize
                )
                .frame(width: style.iconSize, height: style.iconSize)
            } else {
                Image(systemName: alert.pattern.value.systemIconName)
                    .frame(width: style.iconSize, height: style.iconSize)
                    .foregroundColor(.primary)
                    .font(style.iconFont)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 8) {
                    Text(alert.pattern.healthIssue.displayName)
                        .font(style.titleFont)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Circle()
                        .fill(alert.pattern.risk.color)
                        .frame(width: 6, height: 6)
                }
                
                if style.showsDescription {
                    Text(HealthAlertStringFactory.create(alert))
                        .font(style.descriptionFont)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, style == .regular ? 4 : 2)
    }
    

}

#Preview("Regular Style") {
    VStack(spacing: 16) {
        let sampleAlert1 = HealthAlert(
            timePeriod: TimePeriod(date: Date(), timeOfDay: .afternoon),
            pattern: HealthPattern(
                healthIssue: .headache,
                condition: .rapidDecrease,
                value: WeatherMeasurement(parameter: .pressure, value: 1005.0),
                risk: .high
            ),
            currentValue: WeatherMeasurement(parameter: .pressure, value: 1005.0)
        )
        
        let sampleAlert2 = HealthAlert(
            timePeriod: TimePeriod(date: Date(), timeOfDay: .afternoon),
            pattern: HealthPattern(
                healthIssue: .fatigue,
                condition: .above,
                value: WeatherMeasurement(parameter: .humidity, value: 85.0),
                risk: .medium
            ),
            currentValue: WeatherMeasurement(parameter: .humidity, value: 85.0)
        )
        
        let sampleAlert3 = HealthAlert(
            timePeriod: TimePeriod(date: Date(), timeOfDay: .afternoon),
            pattern: HealthPattern(
                healthIssue: .respiratory,
                condition: .above,
                value: WeatherMeasurement(parameter: .weatherCondition, value: 1.0), // Sunny
                risk: .high
            ),
            currentValue: WeatherMeasurement(parameter: .weatherCondition, value: 1.0)
        )
        
        HealthAlertView(alert: sampleAlert1)
        HealthAlertView(alert: sampleAlert2)
        HealthAlertView(alert: sampleAlert3)
    }
    .padding()
}

#Preview("Small Style") {
    VStack(spacing: 8) {
        let sampleAlert1 = HealthAlert(
            timePeriod: TimePeriod(date: Date(), timeOfDay: .afternoon),
            pattern: HealthPattern(
                healthIssue: .headache,
                condition: .rapidDecrease,
                value: WeatherMeasurement(parameter: .pressure, value: 1005.0),
                risk: .high
            ),
            currentValue: WeatherMeasurement(parameter: .pressure, value: 1005.0)
        )
        
        let sampleAlert2 = HealthAlert(
            timePeriod: TimePeriod(date: Date(), timeOfDay: .afternoon),
            pattern: HealthPattern(
                healthIssue: .fatigue,
                condition: .above,
                value: WeatherMeasurement(parameter: .humidity, value: 85.0),
                risk: .medium
            ),
            currentValue: WeatherMeasurement(parameter: .humidity, value: 85.0)
        )
        
        let sampleAlert3 = HealthAlert(
            timePeriod: TimePeriod(date: Date(), timeOfDay: .afternoon),
            pattern: HealthPattern(
                healthIssue: .respiratory,
                condition: .above,
                value: WeatherMeasurement(parameter: .weatherCondition, value: 2.0), // Partly Cloudy
                risk: .high
            ),
            currentValue: WeatherMeasurement(parameter: .weatherCondition, value: 2.0)
        )
        
        HealthAlertView(alert: sampleAlert1, style: .small)
        HealthAlertView(alert: sampleAlert2, style: .small)
        HealthAlertView(alert: sampleAlert3, style: .small)
    }
    .padding()
}
