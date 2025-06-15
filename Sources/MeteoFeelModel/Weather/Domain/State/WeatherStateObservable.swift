import Foundation
import Observation

@Observable
final class WeatherStateObservable: @unchecked Sendable {

    // MARK: - State

    enum State {
        case idle
        case fetching
        case loaded([Weather])
        case refreshing([Weather])
        case error(WeatherServiceError)
        
        var isFetching: Bool {
            switch self {
            case .fetching, .refreshing: true
            case .idle, .loaded, .error: false
            }
        }
        
        var forecasts: [Weather]? {
            switch self {
            case .loaded(let weather), .refreshing(let weather): weather
            case .fetching, .idle, .error: nil
            }
        }
    }

    // MARK: - Properties
    
    private(set) var state: State = .idle
    private let service: WeatherServiceProtocol
    private let repository: WeatherRepositoryProtocol
    private let calendar: Calendar
    private var fetchTask: Task<Void, Never>?

    // MARK: - Lifecycle
    
    init(
        service: WeatherServiceProtocol,
        repository: WeatherRepositoryProtocol,
        calendar: Calendar = .current
    ) {
        self.service = service
        self.repository = repository
        self.calendar = calendar
        Task { @Sendable in
            await setInitialState()
        }
    }

    private func setInitialState() async {
        do {
            let forecasts = try await getRelevantForecasts()
            state = forecasts.isEmpty ? .idle : .loaded(forecasts)
        } catch {
            state = .idle
        }
    }

    // MARK: - Actions
    
    func onAppear() {
        Task { @Sendable in
            await checkAndRefreshIfNeeded()
        }
    }
    
    func refresh() async {
        guard !state.isFetching else { return }
        await fetch()
    }
    
    // MARK: - Data fetching
    
    private func checkAndRefreshIfNeeded() async {
        guard let forecasts = state.forecasts,
              let mostRecentForecast = forecasts.max(by: { $0.fetchedAt < $1.fetchedAt }),
              !calendar.isDateInToday(mostRecentForecast.fetchedAt)
        else { return await refresh() }
    }
    
    private func fetch() async {
        handleFetchingStarted()
        
        fetchTask = Task {
            do {
                // TODO: Replace with proper location service implementation
                // Current coordinates are for EPGL Airport - Gliwice, Poland
                let forecast = try await service.getForecast(
                    coordinates: .gliwiceAirport,
                    days: 3
                )
                
                try await handleNewForecast(forecast)
                
            } catch {
                handleError(error)
            }
        }
        
        await fetchTask?.value
    }

    private func handleFetchingStarted() {
        fetchTask?.cancel()

        if let forecasts = state.forecasts {
            state = .refreshing(forecasts)
        } else {
            state = .fetching
        }
    }

    // MARK: - Data handling
    
    private func handleNewForecast(_ forecast: [Weather]) async throws {
        guard !Task.isCancelled else { return }
        
        try await repository.saveForecasts(forecast)
        
        let relevantForecasts = try await getRelevantForecasts()
        state = .loaded(relevantForecasts)
    }

    private func handleError(_ error: Error) {
        if !Task.isCancelled {
            state = .error(.apiError(.networkError(error)))
        }
    }
    
    private func getRelevantForecasts() async throws -> [Weather] {
        return try await repository.getForecasts(for: Date(), nextPeriods: 3)
    }
}