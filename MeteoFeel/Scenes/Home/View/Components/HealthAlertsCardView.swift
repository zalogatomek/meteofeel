import SwiftUI
import MeteoFeelModel

struct HealthAlertsCardView: View {
    
    // MARK: - Properties
    
    let alerts: [HealthAlert]?
    
    // MARK: - Lifecycle
    
    init(alerts: [HealthAlert]?) {
        self.alerts = alerts
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let alerts, !alerts.isEmpty {
                ForEach(Array(alerts.enumerated()), id: \.element.id) { index, alert in
                    VStack(spacing: 0) {
                        HealthAlertView(alert: alert)
                        
                        if index < alerts.count - 1 {
                            Divider()
                                .padding(.vertical, 4)
                                .padding(.top, 8)
                        }
                    }
                }
            } else {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .frame(width: 24, height: 24)
                        .foregroundColor(alerts != nil ? .green : .black)
                        .font(.title2)
                    
                    Text("No health concerns detected")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .redacted(alerts == nil)
        .cardStyle()
    }
}

// MARK: - Preview

#Preview("With Alerts") {
    let sampleAlerts = [
        HealthAlert(
            timePeriod: TimePeriod(date: Date(), timeOfDay: .afternoon),
            pattern: HealthPattern(
                healthIssue: .headache,
                condition: .rapidDecrease,
                value: WeatherMeasurement(parameter: .pressure, value: 1005.0),
                risk: .high
            ),
            currentValue: WeatherMeasurement(parameter: .pressure, value: 1005.0)
        ),
        HealthAlert(
            timePeriod: TimePeriod(date: Date(), timeOfDay: .afternoon),
            pattern: HealthPattern(
                healthIssue: .fatigue,
                condition: .above,
                value: WeatherMeasurement(parameter: .humidity, value: 85.0),
                risk: .medium
            ),
            currentValue: WeatherMeasurement(parameter: .humidity, value: 85.0)
        )
    ]
    
    HealthAlertsCardView(alerts: sampleAlerts)
        .padding()
}

#Preview("No Alerts") {
    HealthAlertsCardView(alerts: [])
        .padding()
}

#Preview("Loading State") {
    HealthAlertsCardView(alerts: nil)
        .padding()
} 
