import SwiftUI
import MeteoFeelModel

struct ForecastDetailsView: View {
    
    // MARK: - Properties
    
    private let forecast: WeatherForecast
    private let onDismiss: () -> Void

    // MARK: - Lifecycle

    init(forecast: WeatherForecast, onDismiss: @escaping () -> Void) {
        self.forecast = forecast
        self.onDismiss = onDismiss
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    HStack(alignment: .top, spacing: 0) {
                        Text(TimePeriodStringFactory.createForecastHeader(forecast.weather.timePeriod))
                            .font(.title.bold())
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer(minLength: 44) // space for the close button
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Weather Conditions")
                                .font(.headline)
                            
                            WeatherCardView(forecast: forecast)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Health Alerts")
                                .font(.headline)
                            
                            HealthAlertsCardView(alerts: forecast.alerts)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .overlay(alignment: .topTrailing) {
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .padding()
            .padding(.top, 4)
        }
    }
}

#Preview {
    let sampleWeather = Weather(
        condition: .partlyCloudy,
        temperature: 26.0,
        pressure: 1013.0,
        humidity: 65.0,
        windSpeed: 12.0,
        windDirection: 180.0,
        timePeriod: TimePeriod(date: Date(), timeOfDay: .morning)
    )
    
    let sampleAlerts = [
        HealthAlert(
            timePeriod: TimePeriod(date: Date(), timeOfDay: .morning),
            pattern: HealthPattern(
                healthIssue: .headache,
                condition: .rapidDecrease,
                value: WeatherMeasurement(parameter: .pressure, value: 1005.0),
                risk: .high
            ),
            currentValue: WeatherMeasurement(parameter: .pressure, value: 1005.0)
        ),
        HealthAlert(
            timePeriod: TimePeriod(date: Date(), timeOfDay: .morning),
            pattern: HealthPattern(
                healthIssue: .fatigue,
                condition: .above,
                value: WeatherMeasurement(parameter: .humidity, value: 85.0),
                risk: .medium
            ),
            currentValue: WeatherMeasurement(parameter: .humidity, value: 85.0)
        )
    ]
    
    let sampleForecast = WeatherForecast(
        weather: sampleWeather,
        alerts: sampleAlerts
    )
    
    ForecastDetailsView(
        forecast: sampleForecast,
        onDismiss: {}
    )
} 
