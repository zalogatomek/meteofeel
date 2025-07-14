import MeteoFeelModel
import SwiftUI

struct ForecastCardView: View {
    
    // MARK: - Properties
    
    let forecast: WeatherForecast
    
    // MARK: - Initialization
    
    init(forecast: WeatherForecast) {
        self.forecast = forecast
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(TimePeriodStringFactory.create(forecast.weather.timePeriod))
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 12) {
                WeatherConditionIcon(condition: forecast.weather.condition, size: 24)
                
                Text(forecast.weather.condition.displayName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            HStack(spacing: 8) {
                WeatherMeasurementView(
                    measurement: WeatherMeasurement(
                        parameter: .temperature, value: forecast.weather.temperature),
                    style: .small
                )
                
                WeatherMeasurementView(
                    measurement: WeatherMeasurement(parameter: .humidity, value: forecast.weather.humidity),
                    style: .small
                )
                
                WeatherMeasurementView(
                    measurement: WeatherMeasurement(parameter: .pressure, value: forecast.weather.pressure),
                    style: .small
                )
                
                WeatherMeasurementView(
                    measurement: WeatherMeasurement(parameter: .windSpeed, value: forecast.weather.windSpeed),
                    style: .small
                )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                if !forecast.alerts.isEmpty {
                    ForEach(Array(forecast.alerts.prefix(2).enumerated()), id: \.element.id) { index, alert in
                        HealthAlertView(
                            alert: alert,
                            style: .small
                        )
                        
                        if index < min(forecast.alerts.count, 2) - 1 {
                            Divider()
                                .padding(.vertical, 2)
                        }
                    }
                    
                    if forecast.alerts.count > 2 {
                        HStack {
                            Text("+\(forecast.alerts.count - 2) more alerts")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                        .padding(.top, 4)
                    }
                } else {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                        
                        Text("No health concerns")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .cardStyle()
    }
    

}

#Preview {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 16) {
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
                ),
                HealthAlert(
                    timePeriod: TimePeriod(date: Date(), timeOfDay: .morning),
                    pattern: HealthPattern(
                        healthIssue: .respiratory,
                        condition: .above,
                        value: WeatherMeasurement(parameter: .humidity, value: 85.0),
                        risk: .medium
                    ),
                    currentValue: WeatherMeasurement(parameter: .humidity, value: 85.0)
                ),
            ]
            
            let sampleForecast = WeatherForecast(
                weather: sampleWeather,
                alerts: sampleAlerts
            )
            
            ForecastCardView(forecast: sampleForecast)
                .containerRelativeFrame(.horizontal) { width, _ in
                    width * 0.75
                }
            
            let sampleWeather2 = Weather(
                condition: .thunderstorm,
                temperature: 22.0,
                pressure: 1005.0,
                humidity: 85.0,
                windSpeed: 25.0,
                windDirection: 180.0,
                timePeriod: TimePeriod(date: Date(), timeOfDay: .afternoon)
            )
            
            let sampleForecast2 = WeatherForecast(
                weather: sampleWeather2,
                alerts: []
            )
            
            ForecastCardView(forecast: sampleForecast2)
                .containerRelativeFrame(.horizontal) { width, _ in
                    width * 0.75
                }
        }
        .padding()
    }
}
