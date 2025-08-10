import SwiftUI
import MeteoFeelModel

struct HealthAlertsCardView: View {
    
    // MARK: - Properties
    
    private let alerts: [HealthAlert]?
    
    // MARK: - Lifecycle
    
    init(alerts: [HealthAlert]?) {
        self.alerts = alerts
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let alerts, !alerts.isEmpty {
                let sortedAlertsGroups = alerts
                    .groupByHealthIssue()
                    .sorted { $0.key < $1.key }
                
                ForEach(Array(sortedAlertsGroups.enumerated()), id: \.offset) { index, group in
                    VStack(spacing: 0) {
                        GroupedHealthAlertView(healthIssue: group.key, alerts: group.value)
                        
                        if index < sortedAlertsGroups.count - 1 {
                            Divider()
                                .padding(.vertical, 8)
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

// MARK: - Grouped Health Alert View

struct GroupedHealthAlertView: View {
    
    // MARK: - Properties
    
    private let healthIssue: HealthIssue
    private let alerts: [HealthAlert]
    
    // MARK: - Lifecycle
    
    init(healthIssue: HealthIssue, alerts: [HealthAlert]) {
        self.healthIssue = healthIssue
        self.alerts = alerts
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: healthIssue.systemIconName)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.primary)
                    .font(.title3)
                
                Text(healthIssue.displayName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let highestRisk = alerts.map({ $0.pattern.risk }).max() {
                    Text(highestRisk.displayName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(highestRisk.color)
                        .cornerRadius(4)
                }
            }
            
            VStack(spacing: 4) {
                ForEach(Array(alerts.enumerated()), id: \.offset) { index, alert in
                    HealthAlertView(alert: alert, style: .grouped)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview

#Preview("With Multiple Alerts for Same Issue") {
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
                healthIssue: .headache,
                condition: .above,
                value: WeatherMeasurement(parameter: .temperature, value: 28.0),
                risk: .medium
            ),
            currentValue: WeatherMeasurement(parameter: .temperature, value: 28.0)
        ),
        HealthAlert(
            timePeriod: TimePeriod(date: Date(), timeOfDay: .afternoon),
            pattern: HealthPattern(
                healthIssue: .headache,
                condition: .above,
                value: WeatherMeasurement(parameter: .humidity, value: 85.0),
                risk: .medium
            ),
            currentValue: WeatherMeasurement(parameter: .humidity, value: 85.0)
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
        ),
        HealthAlert(
            timePeriod: TimePeriod(date: Date(), timeOfDay: .afternoon),
            pattern: HealthPattern(
                healthIssue: .respiratory,
                condition: .equals,
                value: WeatherMeasurement(parameter: .weatherCondition, value: 8.0), // Foggy
                risk: .high
            ),
            currentValue: WeatherMeasurement(parameter: .weatherCondition, value: 8.0)
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
