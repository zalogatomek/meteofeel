import SwiftUI
import MeteoFeelModel

struct HomeView: View {
    
    // MARK: - Properties
    
    @State private var viewModel: HomeViewModel
    
    // MARK: - Lifecycle
    
    init() {
        let stateObservable = WeatherForecastStateObservableFactory.create(
            apiKey: WeatherApiConfiguration.apiKey,
            profileService: ProfileServiceFactory.create()
        )
        self.viewModel = HomeViewModel(stateObservable: stateObservable)
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationStack {
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
                                        HStack(alignment: .top, spacing: 16) {
                                            ForEach(viewModel.forecasts, id: \.weather.timePeriod) { forecast in
                                                NavigationLink(destination: ForecastDetailsView(forecast: forecast)) {
                                                    ForecastCardView(forecast: forecast)
                                                        .containerRelativeFrame(.horizontal) { width, _ in
                                                            width * 0.75
                                                        }
                                                }
                                                .buttonStyle(PlainButtonStyle())
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
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView().id(UUID())) {
                        Image(systemName: "gearshape")
                            .font(.title2)
                    }
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
}

#Preview {
    HomeView()
}
