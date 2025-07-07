import Foundation

enum WeatherServiceError: Error {
    case apiError(WeatherAPIError)
    case mappingError
}

protocol WeatherServiceProtocol: Sendable {
    func getForecast(coordinates: Coordinates, days: Int) async throws -> [Weather]
}

final class WeatherService: WeatherServiceProtocol {
    private let apiClient: WeatherAPIClientProtocol
    
    init(apiClient: WeatherAPIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getForecast(coordinates: Coordinates, days: Int) async throws -> [Weather] {
        do {
            let response = try await apiClient.fetchForecast(coordinates: coordinates, days: days)
            guard let forecast = WeatherMapper.mapForecast(response) else {
                throw WeatherServiceError.mappingError
            }
            return forecast
        } catch let error as WeatherAPIError {
            throw WeatherServiceError.apiError(error)
        }
    }
} 