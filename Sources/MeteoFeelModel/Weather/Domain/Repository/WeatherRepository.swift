import Foundation

protocol WeatherRepositoryProtocol {
    func saveForecasts(_ forecasts: [Weather]) async throws
    func getForecast(for date: Date) async throws -> Weather?
    func getForecast(for timePeriod: TimePeriod) async throws -> Weather?
    func getForecasts(for periods: [TimePeriod]) async throws -> [Weather]
    func getForecasts(for date: Date, nextPeriods count: Int) async throws -> [Weather]
    func getHistoricalForecasts(from startDate: Date, to endDate: Date) async throws -> [Weather]
    func cleanupOldData(olderThan date: Date) async throws
} 