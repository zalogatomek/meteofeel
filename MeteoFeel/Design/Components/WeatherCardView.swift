import SwiftUI
import MeteoFeelModel

struct WeatherCardView: View {
    
    // MARK: - Properties
    
    private let forecast: WeatherForecast?

    // MARK: - Lifecycle

    init(forecast: WeatherForecast?) {
        self.forecast = forecast
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                WeatherConditionIcon(condition: forecast?.weather.condition, size: 24)
                
                Text(forecast?.weather.condition.displayName ?? String.placeholder(length: 5))
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .redacted(forecast == nil)
            
            HStack(spacing: 8) {
                WeatherMeasurementView(
                    measurement: (forecast?.weather.temperature).map { WeatherMeasurement(parameter: .temperature, value: $0) }
                )
                
                WeatherMeasurementView(
                    measurement: (forecast?.weather.humidity).map { WeatherMeasurement(parameter: .humidity, value: $0) }
                )

                WeatherMeasurementView(
                    measurement: (forecast?.weather.pressure).map { WeatherMeasurement(parameter: .pressure, value: $0) }
                )
                
                WeatherMeasurementView(
                    measurement: (forecast?.weather.windSpeed).map { WeatherMeasurement(parameter: .windSpeed, value: $0) }
                )
            }
        }
        .cardStyle()
    }
}

#Preview("With Data") {
    let sampleWeather = Weather(
        condition: .sunny,
        temperature: 22.0,
        pressure: 1013.0,
        humidity: 65.0,
        windSpeed: 12.0,
        windDirection: 180.0,
        timePeriod: TimePeriod(date: Date(), timeOfDay: .afternoon)
    )
    
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
        )
    ]
    
    let sampleForecast = WeatherForecast(
        weather: sampleWeather,
        alerts: sampleAlerts
    )
    
    WeatherCardView(
        forecast: sampleForecast
    )
    .padding()
}

#Preview("Loading State") {
    WeatherCardView(
        forecast: nil
    )
    .padding()
} 
