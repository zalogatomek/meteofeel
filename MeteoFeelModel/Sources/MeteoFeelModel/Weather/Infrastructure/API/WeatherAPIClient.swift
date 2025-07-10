import Foundation

public enum WeatherAPIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case rateLimitExceeded
    case serverError(Int)
}

protocol WeatherAPIClientProtocol: Sendable {
    func fetchForecast(coordinates: Coordinates, days: Int) async throws -> WeatherResponse
}

final class WeatherAPIClient: WeatherAPIClientProtocol {
    private let baseURL = "https://api.weatherapi.com/v1"
    private let apiKey: String
    private let session: URLSession
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    func fetchForecast(coordinates: Coordinates, days: Int) async throws -> WeatherResponse {
        let endpoint = "\(baseURL)/forecast.json"
        let queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: "\(coordinates.latitude),\(coordinates.longitude)"),
            URLQueryItem(name: "days", value: "\(days)"),
            URLQueryItem(name: "aqi", value: "yes")
        ]
        
        return try await performRequest(endpoint: endpoint, queryItems: queryItems)
    }
    
    private func performRequest(endpoint: String, queryItems: [URLQueryItem]) async throws -> WeatherResponse {
        guard var components = URLComponents(string: endpoint) else {
            throw WeatherAPIError.invalidURL
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw WeatherAPIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw WeatherAPIError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200:
                do {
                    return try jsonDecoder.decode(WeatherResponse.self, from: data)
                } catch {
                    throw WeatherAPIError.decodingError(error)
                }
            case 429:
                throw WeatherAPIError.rateLimitExceeded
            default:
                throw WeatherAPIError.serverError(httpResponse.statusCode)
            }
        } catch let error as WeatherAPIError {
            throw error
        } catch {
            throw WeatherAPIError.networkError(error)
        }
    }
} 
