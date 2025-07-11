import SwiftUI
import MeteoFeelModel

struct HomeView: View {
    
    // MARK: - Properties
    
    @State private var viewModel: HomeViewModel
    
    // MARK: - Lifecycle
    
    init() {
        let stateObservable = WeatherForecastStateObservableFactory.create(apiKey: WeatherApiConfiguration.apiKey)
        self.viewModel = HomeViewModel(stateObservable: stateObservable)
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.greeting)
                            .font(.title.bold())
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Current Weather")
                                .font(.headline)
                            
                            WeatherCardView(
                                forecast: viewModel.currentForecast
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Health Alerts")
                                .font(.headline)
                            
                            HealthAlertsCardView(alerts: viewModel.currentForecast?.alerts)
                        }
                        
                        if !viewModel.forecasts.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Upcoming Conditions")
                                    .font(.headline)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(viewModel.forecasts, id: \.weather.timePeriod) { forecast in
                                            ForecastCardView(
                                                time: viewModel.timePeriodText(forecast.weather.timePeriod),
                                                weather: forecast.weather.condition.displayName,
                                                temp: forecast.weather.temperature.formattedTemperature,
                                                healthStatus: forecast.alerts.isEmpty ? "No health concerns" : "Health alerts active",
                                                severity: forecast.alerts.isEmpty ? .low : .high,
                                                weatherCondition: forecast.weather.condition,
                                                healthIconName: forecast.alerts.isEmpty ? "checkmark.circle.fill" : "exclamationmark.triangle.fill"
                                            )
                                            .containerRelativeFrame(.horizontal) { width, _ in
                                                width * 0.7
                                            }
                                        }
                                    }
                                }
                                .scrollClipDisabled()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
}

#Preview {
    HomeView()
}
