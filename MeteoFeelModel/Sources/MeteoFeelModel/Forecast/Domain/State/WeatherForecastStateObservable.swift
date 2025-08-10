import Foundation

public actor WeatherForecastStateObservable {

    // MARK: - State

    public enum State: Sendable {
        case idle
        case fetching
        case loaded([WeatherForecast])
        case refreshing([WeatherForecast])
        case error(WeatherForecastServiceError)
        
        public var isFetching: Bool {
            switch self {
            case .fetching, .refreshing: true
            case .idle, .loaded, .error: false
            }
        }
        
        public var forecasts: [WeatherForecast]? {
            switch self {
            case .loaded(let forecasts), .refreshing(let forecasts): forecasts
            case .fetching, .idle, .error: nil
            }
        }
    }

    public private(set) var state: State {
        didSet {
            stateContinuation.yield(state)
        }
    }

    public let stateStream: AsyncStream<State>
    private let stateContinuation: AsyncStream<State>.Continuation

    // MARK: - Properties
    
    private let refreshService: any WeatherForecastRefreshServiceProtocol
    private let store: any WeatherForecastStoreProtocol
    private let getUserProfile: () async -> UserProfile?

    // MARK: - Lifecycle
    
    init(
        refreshService: any WeatherForecastRefreshServiceProtocol,
        store: any WeatherForecastStoreProtocol,
        getUserProfile: @escaping () async -> UserProfile?
    ) {
        self.refreshService = refreshService
        self.store = store
        self.getUserProfile = getUserProfile
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
    
    public func onAppear() {
        Task {
            await checkAndRefreshIfNeeded()
        }
    }
    
    public func refresh() async {
        guard !state.isFetching else { return }
        await fetch()
    }
    
    // MARK: - Data fetching
    
    private func checkAndRefreshIfNeeded() async {
        guard await refreshService.shouldRefreshForecasts() else { return }
        await refresh()
    }
    
    private func fetch() async {
        handleFetchingStarted()
        
        do {
            try await refreshService.refreshForecasts()
            let relevantForecasts = try await getRelevantForecasts(store: store)
            state = .loaded(relevantForecasts)
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

    private func handleError(_ error: any Error) {
        if let forecastError = error as? WeatherForecastServiceError {
            state = .error(forecastError)
        } else {
            state = .error(.mappingError)
        }
    }
    
    private func getRelevantForecasts(store: any WeatherForecastStoreProtocol) async throws -> [WeatherForecast] {
        let healthIssues = await getUserProfile()?.healthIssues ?? Set(HealthIssue.allCases)
        let forecasts = try await store.getForecasts(for: Date(), nextPeriods: 3)
        return forecasts.map { $0.byFilteringHealthIssues(healthIssues) }
    }
} 
