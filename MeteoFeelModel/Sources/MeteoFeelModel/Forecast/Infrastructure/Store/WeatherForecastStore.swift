import Foundation

protocol WeatherForecastStoreProtocol: Sendable {
    func saveForecasts(_ forecasts: [WeatherForecast]) async throws
    func getForecast(for date: Date) async throws -> WeatherForecast?
    func getForecast(for timePeriod: TimePeriod) async throws -> WeatherForecast?
    func getForecasts(for periods: [TimePeriod]) async throws -> [WeatherForecast]
    func getForecasts(for date: Date, nextPeriods count: Int) async throws -> [WeatherForecast]
    func getHistoricalForecasts(from startDate: Date, to endDate: Date) async throws -> [WeatherForecast]
    func cleanupOldData(olderThan date: Date) async throws
}

enum WeatherForecastStoreError: Error {
    case saveError
    case loadError
    case dataNotFound
    case invalidData
}

actor WeatherForecastStore: WeatherForecastStoreProtocol {

    // MARK: - Keys

    private enum Keys {
        static let forecasts = "weather_forecasts"
    }

    // MARK: - Properties

    private let defaults: UserDefaults
    private let dateFormatter: ISO8601DateFormatter
    
    // MARK: - Lifecycle
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.dateFormatter = ISO8601DateFormatter()
    }

    // MARK: - Save
    
    func saveForecasts(_ forecasts: [WeatherForecast]) async throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            var existingForecasts = try await getAllForecasts()
            
            for newForecast in forecasts {
                if let index = existingForecasts.firstIndex(where: { $0.weather.timePeriod == newForecast.weather.timePeriod }) {
                    let existingForecast = existingForecasts[index]
                    if newForecast.weather.fetchedAt > existingForecast.weather.fetchedAt {
                        existingForecasts[index] = newForecast
                    }
                } else {
                    existingForecasts.append(newForecast)
                }
            }
            
            let data = try encoder.encode(existingForecasts.sorted(by: { 
                $0.weather.timePeriod < $1.weather.timePeriod 
            }))
            defaults.set(data, forKey: Keys.forecasts)
        } catch {
            throw WeatherForecastStoreError.saveError
        }
    }

    // MARK: - Get

    func getForecast(for date: Date) async throws -> WeatherForecast? {
        guard let timePeriod = TimePeriod(date: date, calendar: calendar) 
        else { return nil }
        return try await getForecast(for: timePeriod)
    }
    
    func getForecast(for timePeriod: TimePeriod) async throws -> WeatherForecast? {
        let forecasts = try await getAllForecasts()
        return forecasts.first { $0.weather.timePeriod == timePeriod }
    }
    
    func getForecasts(for periods: [TimePeriod]) async throws -> [WeatherForecast] {
        let forecasts = try await getAllForecasts()
        return periods.compactMap { period in
            forecasts.first { $0.weather.timePeriod == period }
        }
    }

    func getForecasts(for date: Date, nextPeriods count: Int) async throws -> [WeatherForecast] {
        let periods = getTimePeriods(for: date, count: count)
        return try await getForecasts(for: periods)
    }
    
    func getHistoricalForecasts(from startDate: Date, to endDate: Date) async throws -> [WeatherForecast] {
        let forecasts = try await getAllForecasts()
        return forecasts.filter { forecast in
            let date = forecast.weather.timePeriod.date
            return date >= startDate && date <= endDate
        }
    }
    
    func cleanupOldData(olderThan date: Date) async throws {
        let forecasts = try await getAllForecasts()
        let filteredForecasts = forecasts.filter { $0.weather.timePeriod.date >= date }
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(filteredForecasts)
            defaults.set(data, forKey: Keys.forecasts)
        } catch {
            throw WeatherForecastStoreError.saveError
        }
    }
    
    // MARK: - Helpers
    
    private func getAllForecasts() async throws -> [WeatherForecast] {
        guard let data = defaults.data(forKey: Keys.forecasts)
        else { return [] }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            return try decoder.decode([WeatherForecast].self, from: data)
        } catch {
            throw WeatherForecastStoreError.invalidData
        }
    }
    
    private func getTimePeriods(for date: Date, count: Int) -> [TimePeriod] {
        let currentPeriod = TimePeriod(date: date, calendar: calendar) ?? TimePeriod(date: date, timeOfDay: .morning)
        var periods = [currentPeriod]
        
        var nextPeriod = currentPeriod
        for _ in 0..<count {
            nextPeriod = nextPeriod.next(calendar: calendar)
            periods.append(nextPeriod)
        }
        
        return periods
    }
    
    private var calendar: Calendar { .current }
} 
