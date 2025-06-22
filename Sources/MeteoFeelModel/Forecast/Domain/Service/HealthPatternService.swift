import Foundation

enum HealthPatternServiceError: Error {
    case apiError(HealthPatternAPIError)
    case mappingError
}

protocol HealthPatternServiceProtocol {
    func getPatterns() async throws -> [HealthPattern]
}

final class HealthPatternService: HealthPatternServiceProtocol {
    private let apiClient: HealthPatternAPIClientProtocol
    
    init(apiClient: HealthPatternAPIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getPatterns() async throws -> [HealthPattern] {
        do {
            let response = try await apiClient.fetchPatterns()
            return HealthPatternMapper.map(response)
        } catch let error as HealthPatternAPIError {
            throw HealthPatternServiceError.apiError(error)
        }
    }
} 