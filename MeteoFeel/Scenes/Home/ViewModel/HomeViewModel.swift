import SwiftUI
import Observation
import MeteoFeelModel

@Observable
final class HomeViewModel {
    
    // MARK: - Properties
    
    private let stateObservable: WeatherForecastStateObservable
    private var stateTask: Task<Void, Never>?
    
    // MARK: - Lifecycle
    
    init(stateObservable: WeatherForecastStateObservable) {
        self.stateObservable = stateObservable
        observeState()
    }
    
    deinit {
        stateTask?.cancel()
    }
    
    private func observeState() {
        stateTask = Task {
            for await state in await stateObservable.stateStream {
                await MainActor.run {
                    handle(state: state)
                }
            }
        }
    }
    
    // MARK: - Output
    
    private(set) var isLoading = false
    private(set) var currentForecast: WeatherForecast?
    private(set) var forecasts: [WeatherForecast] = []
    private(set) var errorMessage: String?
    
    // MARK: - Input
    
    func onAppear() {
        Task {
            await stateObservable.onAppear()
        }
    }
    
    func refresh() async {
        await stateObservable.refresh()
    }
    
    // MARK: - Private Methods
    
    @MainActor
    private func handle(state: WeatherForecastStateObservable.State) {
        isLoading = state.isFetching
        
        switch state {
        case .idle:
            currentForecast = nil
            forecasts = []
            errorMessage = nil
            
        case .fetching:
            errorMessage = nil
            
        case .loaded(let weatherForecasts):
            updateWeatherData(from: weatherForecasts)
            errorMessage = nil
            
        case .refreshing(let weatherForecasts):
            updateWeatherData(from: weatherForecasts)
            errorMessage = nil
            
        case .error(let error):
            errorMessage = error.localizedDescription
        }
    }
    
    private func updateWeatherData(from weatherForecasts: [WeatherForecast]) {
        self.forecasts = weatherForecasts
        
        // Set current forecast to the most recent forecast
        if let mostRecentForecast = weatherForecasts.max(by: { $0.weather.fetchedAt < $1.weather.fetchedAt }) {
            self.currentForecast = mostRecentForecast
        }
    }
}

// MARK: - UI Helpers

extension HomeViewModel {
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default: return "Good Evening"
        }
    }
    
    func forecastForTimePeriod(_ timePeriod: TimePeriod) -> WeatherForecast? {
        return forecasts.first { $0.weather.timePeriod == timePeriod }
    }
    
    func timePeriodText(_ timePeriod: TimePeriod) -> String {
        switch timePeriod.timeOfDay {
        case .morning: return "Morning"
        case .afternoon: return "Afternoon"
        case .evening: return "Evening"
        }
    }
} 
