import SwiftUI
import MeteoFeelModel

struct HomeView: View {
    
    // MARK: - Properties
    
    @State private var viewModel: HomeViewModel
    
    // MARK: - Lifecycle
    
    init() {
        let stateObservable = WeatherForecastStateObservableFactory.create(apiKey: "YOUR_API_KEY") // TODO: Replace with actual API key
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
                        Text("\(viewModel.greeting), User")
                            .font(.title.bold())
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    VStack(spacing: 24) {
                        WeatherCardView(
                            forecast: viewModel.currentForecast
                        )
                        
                        if !viewModel.forecasts.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Upcoming Conditions")
                                    .font(.headline)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(viewModel.forecasts, id: \.weather.timePeriod) { forecast in
                                            ForecastCardView(
                                                time: viewModel.timePeriodText(forecast.weather.timePeriod),
                                                weather: viewModel.weatherConditionText(for: forecast.weather),
                                                temp: "\(Int(round(forecast.weather.temperature.value)))°C",
                                                healthStatus: forecast.alerts.isEmpty ? "No health concerns" : "Health alerts active",
                                                severity: forecast.alerts.isEmpty ? .low : .high,
                                                iconName: viewModel.weatherIconName(for: forecast.weather)
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

// MARK: - Supporting Views

struct HealthAlertView: View {
    let alert: HealthAlert
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(alert.pattern.healthIssue.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text("Risk level: \(alert.pattern.risk.displayName)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Extensions

extension HomeViewModel {
    func weatherConditionText(for weather: Weather) -> String {
        switch weather.condition {
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
    
    func weatherIconName(for weather: Weather) -> String {
        switch weather.condition {
        case .sunny: return "sun.max.fill"
        case .partlyCloudy: return "cloud.sun.fill"
        case .cloudy: return "cloud.fill"
        case .rainy: return "cloud.rain.fill"
        case .heavyRain: return "cloud.heavyrain.fill"
        case .snowy: return "cloud.snow.fill"
        case .foggy: return "cloud.fog.fill"
        case .windy: return "wind"
        case .thunderstorm: return "cloud.bolt.rain.fill"
        case .unknown: return "questionmark"
        }
    }
}

extension HealthIssue {
    var displayName: String {
        switch self {
        case .headache: return "Headache"
        case .jointPain: return "Joint Pain"
        case .respiratory: return "Respiratory Issues"
        case .fatigue: return "Fatigue"
        case .allergy: return "Allergy"
        case .asthma: return "Asthma"
        case .mood: return "Mood Changes"
        case .cardiovascular: return "Cardiovascular"
        case .skin: return "Skin Issues"
        }
    }
}

extension HealthRisk {
    var displayName: String {
        switch self {
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
}

#Preview {
    HomeView()
}
