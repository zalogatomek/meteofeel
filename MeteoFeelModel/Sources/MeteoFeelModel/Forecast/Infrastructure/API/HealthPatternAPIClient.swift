import Foundation

enum HealthPatternAPIError: Error {
    case fileNotFound
    case invalidData
    case decodingError(any Error)
}

protocol HealthPatternAPIClientProtocol: Sendable {
    func fetchPatterns() async throws -> HealthPatternResponse
}

final class HealthPatternAPIClient: HealthPatternAPIClientProtocol {
    private let bundle: Bundle
    private let fileName: String
    
    init(bundle: Bundle = .main, fileName: String = "health_patterns") {
        self.bundle = bundle
        self.fileName = fileName
    }
    
    func fetchPatterns() async throws -> HealthPatternResponse {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw HealthPatternAPIError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(HealthPatternResponse.self, from: data)
        } catch let error as DecodingError {
            throw HealthPatternAPIError.decodingError(error)
        } catch {
            throw HealthPatternAPIError.invalidData
        }
    }
} 
