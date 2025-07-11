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

// MARK: - Supporting Views

struct HealthAlertView: View {
    let alert: HealthAlert
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: alert.pattern.value.systemIconName)
                .frame(width: 24, height: 24)
                .foregroundColor(alert.pattern.risk.color)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(alert.pattern.healthIssue.displayName): \(alert.pattern.risk.displayName) risk")
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text(descriptiveMessage)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Helpers
    
    private var descriptiveMessage: String {
        let riskText = alert.pattern.risk.displayName
        let healthIssueText = alert.pattern.healthIssue.displayName.lowercased()
        let conditionText = alert.pattern.condition.displayText
        let parameterText = alert.pattern.value.parameter.displayName.lowercased()
        
        return "\(riskText) risk of \(healthIssueText) due to \(conditionText) \(parameterText)"
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
