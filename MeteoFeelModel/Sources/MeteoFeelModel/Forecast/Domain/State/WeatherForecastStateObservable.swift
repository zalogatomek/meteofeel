import Foundation

actor WeatherForecastStateObservable {

    // MARK: - State

    enum State {
        case idle
        case fetching
        case loaded([WeatherForecast])
        case refreshing([WeatherForecast])
        case error(WeatherForecastServiceError)
        
        var isFetching: Bool {
            switch self {
            case .fetching, .refreshing: true
            case .idle, .loaded, .error: false
            }
        }
        
        var forecasts: [WeatherForecast]? {
            switch self {
            case .loaded(let forecasts), .refreshing(let forecasts): forecasts
            case .fetching, .idle, .error: nil
            }
        }
    }

    var state: State {
        didSet {
            stateContinuation.yield(state)
        }
    }

    let stateStream: AsyncStream<State>
    private let stateContinuation: AsyncStream<State>.Continuation

    // MARK: - Properties
    
    private let service: WeatherForecastServiceProtocol
    private let store: WeatherForecastStoreProtocol
    private let calendar: Calendar

    // MARK: - Lifecycle
    
    init(
        service: WeatherForecastServiceProtocol,
        store: WeatherForecastStoreProtocol,
        calendar: Calendar = .current
    ) {
        self.service = service
        self.store = store
        self.calendar = calendar
        (self.state, self.stateStream, self.stateContinuation) = Self.createStateStream()
        Task { await setInitialState() }
    }
    
    private static func createStateStream() -> (State, AsyncStream<State>, AsyncStream<State>.Continuation) {
        let initialState = State.idle
        let (stream, continuation) = AsyncStream.makeStream(
            of: State.self,
            bufferingPolicy: .bufferingNewest(1)
        )
        continuation.yield(initialState)
        return (initialState, stream, continuation)
    }

    private func setInitialState() async {
        do {
            let forecasts = try await getRelevantForecasts(store: store)
            state = forecasts.isEmpty ? .idle : .loaded(forecasts)
        } catch {
            state = .idle
        }
    }

    // MARK: - Actions
    
    func onAppear() {
        Task {
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
              let mostRecentForecast = forecasts.max(by: { $0.weather.fetchedAt < $1.weather.fetchedAt }),
              !calendar.isDateInToday(mostRecentForecast.weather.fetchedAt)
        else { return await refresh() }
    }
    
    private func fetch() async {
        handleFetchingStarted()
        
        let service = self.service
        let store = self.store
        
        do {
            // TODO: Replace with proper location service implementation
            // Current coordinates are for EPGL Airport - Gliwice, Poland
            let forecasts = try await service.getForecasts(
                coordinates: .gliwiceAirport,
                days: 3
            )
            
            try await handleNewForecasts(forecasts, store: store)
            
        } catch {
            handleError(error)
        }
    }

    private func handleFetchingStarted() {
        if let forecasts = state.forecasts {
            state = .refreshing(forecasts)
        } else {
            state = .fetching
        }
    }

    // MARK: - Data handling
    
    private func handleNewForecasts(_ forecasts: [WeatherForecast], store: WeatherForecastStoreProtocol) async throws {
        try await store.saveForecasts(forecasts)
        
        let relevantForecasts = try await getRelevantForecasts(store: store)
        state = .loaded(relevantForecasts)
    }

    private func handleError(_ error: Error) {
        if let forecastError = error as? WeatherForecastServiceError {
            state = .error(forecastError)
        } else {
            state = .error(.mappingError)
        }
    }
    
    private func getRelevantForecasts(store: WeatherForecastStoreProtocol) async throws -> [WeatherForecast] {
        return try await store.getForecasts(for: Date(), nextPeriods: 3)
    }
} 