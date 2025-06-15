import Foundation

enum WeatherRepositoryError: Error {
    case saveError
    case loadError
    case dataNotFound
    case invalidData
}

final class WeatherRepository: WeatherRepositoryProtocol {

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
    
    func saveForecasts(_ forecasts: [Weather]) async throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            var existingForecasts = try await getAllForecasts()
            
            for newForecast in forecasts {
                if let index = existingForecasts.firstIndex(where: { $0.timePeriod == newForecast.timePeriod }) {
                    let existingForecast = existingForecasts[index]
                    if newForecast.fetchedAt > existingForecast.fetchedAt {
                        existingForecasts[index] = newForecast
                    }
                } else {
                    existingForecasts.append(newForecast)
                }
            }
            
            let data = try encoder.encode(existingForecasts.sorted(by: { 
                $0.timePeriod < $1.timePeriod 
            }))
            defaults.set(data, forKey: Keys.forecasts)
        } catch {
            throw WeatherRepositoryError.saveError
        }
    }

    // MARK: - Get

    func getForecast(for date: Date) async throws -> Weather? {
        guard let timePeriod = TimePeriod(date: date, calendar: calendar) 
        else { return nil }
        return try await getForecast(for: timePeriod)
    }
    
    func getForecast(for timePeriod: TimePeriod) async throws -> Weather? {
        let forecasts = try await getAllForecasts()
        return forecasts.first { $0.timePeriod == timePeriod }
    }
    
    func getForecasts(for periods: [TimePeriod]) async throws -> [Weather] {
        let forecasts = try await getAllForecasts()
        return periods.compactMap { period in
            forecasts.first { $0.timePeriod == period }
        }
    }

    func getForecasts(for date: Date, nextPeriods count: Int) async throws -> [Weather] {
        let periods = getTimePeriods(for: date, count: count)
        return try await getForecasts(for: periods)
    }
    
    func getHistoricalForecasts(from startDate: Date, to endDate: Date) async throws -> [Weather] {
        let forecasts = try await getAllForecasts()
        return forecasts.filter { forecast in
            let date = forecast.timePeriod.date
            return date >= startDate && date <= endDate
        }
    }
    
    func cleanupOldData(olderThan date: Date) async throws {
        let forecasts = try await getAllForecasts()
        let filteredForecasts = forecasts.filter { $0.timePeriod.date >= date }
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(filteredForecasts)
            defaults.set(data, forKey: Keys.forecasts)
        } catch {
            throw WeatherRepositoryError.saveError
        }
    }
    
    // MARK: - Helpers
    
    private func getAllForecasts() async throws -> [Weather] {
        guard let data = defaults.data(forKey: Keys.forecasts)
        else { return [] }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            return try decoder.decode([Weather].self, from: data)
        } catch {
            throw WeatherRepositoryError.invalidData
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