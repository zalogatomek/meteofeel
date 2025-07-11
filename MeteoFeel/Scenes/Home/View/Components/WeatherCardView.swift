import SwiftUI
import MeteoFeelModel

struct WeatherCardView: View {
    
    // MARK: - Properties
    
    let forecast: WeatherForecast?
    
    // MARK: - Lifecycle
    
    init(forecast: WeatherForecast?) {
        self.forecast = forecast
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 16) {
            // Weather condition header
            HStack(spacing: 12) {
                WeatherConditionIcon(condition: forecast?.weather.condition, size: 24)
                
                Text(weatherConditionText)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .redacted(forecast == nil)
            
            // Weather metrics
            HStack(spacing: 8) {
                WeatherMetricView(
                    iconName: "thermometer",
                    value: temperatureText,
                    label: "Temperature"
                )
                
                WeatherMetricView(
                    iconName: "humidity",
                    value: humidityText,
                    label: "Humidity"
                )
                
                WeatherMetricView(
                    iconName: "wind",
                    value: windSpeedText,
                    label: "Wind"
                )
                
                WeatherMetricView(
                    iconName: "gauge",
                    value: pressureText,
                    label: "Pressure"
                )
            }
            
            if let forecast, !forecast.alerts.isEmpty {
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Health Alerts")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    ForEach(forecast.alerts, id: \.id) { alert in
                        HealthAlertView(alert: alert)
                    }
                }
            }
        }
        .cardStyle()
    }
    
    // MARK: - Private Properties
    
    private var weatherConditionText: String {
        guard let forecast = forecast else { return "Unknown" }
        
        switch forecast.weather.condition {
        case .sunny: return "Sunny"
        case .partlyCloudy: return "Partly Cloudy"
        case .cloudy: return "Cloudy"
        case .rainy: return "Light Rain"
        case .heavyRain: return "Heavy Rain"
        case .snowy: return "Snow"
        case .foggy: return "Foggy"
        case .windy: return "Windy"
        case .thunderstorm: return "Thunderstorm"
        case .unknown: return "Unknown"
        }
    }
    
    private var temperatureText: String? {
        guard let forecast else { return nil }
        return "\(Int(round(forecast.weather.temperature.value)))°C"
    }
    
    private var humidityText: String? {
        guard let forecast else { return nil }
        return "\(Int(round(forecast.weather.humidity)))%"
    }
    
    private var windSpeedText: String? {
        guard let forecast else { return nil }
        let kmh = forecast.weather.windSpeed.converted(to: .kilometersPerHour)
        return "\(Int(round(kmh.value))) km/h"
    }
    
    private var pressureText: String? {
        guard let forecast else { return nil }
        let hPa = forecast.weather.pressure.converted(to: .hectopascals)
        return "\(Int(round(hPa.value))) hPa"
    }
    

}

#Preview("With Data") {
    let sampleWeather = Weather(
        condition: .sunny,
        temperature: Measurement(value: 22, unit: UnitTemperature.celsius),
        pressure: Measurement(value: 1013, unit: UnitPressure.millibars),
        humidity: 65,
        windSpeed: Measurement(value: 12, unit: UnitSpeed.kilometersPerHour),
        windDirection: Measurement(value: 180, unit: UnitAngle.degrees),
        timePeriod: TimePeriod(date: Date(), timeOfDay: .afternoon)
    )
    
    let sampleAlerts = [
        HealthAlert(
            timePeriod: TimePeriod(date: Date(), timeOfDay: .afternoon),
            pattern: HealthPattern(
                healthIssue: .headache,
                parameter: .pressure,
                condition: .rapidDecrease,
                value: .pressure(Measurement(value: 1005, unit: UnitPressure.millibars)),
                risk: .high
            ),
            currentValue: .pressure(Measurement(value: 1005, unit: UnitPressure.millibars))
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
