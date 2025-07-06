import Foundation

protocol HealthPatternStoreProtocol: Sendable {
    func getPatterns() async throws -> [HealthPattern]
    func getPatterns(for healthIssues: [HealthIssue]) async throws -> [HealthPattern]
}

enum HealthPatternStoreError: Error {
    case loadFailed
    case fileNotFound
}

actor HealthPatternStore: HealthPatternStoreProtocol {
    
    // MARK: - Properties
    
    private let bundle: Bundle
    private let fileName: String
    
    // MARK: - Lifecycle
    
    init(bundle: Bundle = .main, fileName: String = "health_patterns") {
        self.bundle = bundle
        self.fileName = fileName
    }
    
    // MARK: - HealthPatternStoreProtocol
    
    func getPatterns() async throws -> [HealthPattern] {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw HealthPatternStoreError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(HealthPatternResponse.self, from: data)
            return HealthPatternMapper.map(response)
        } catch {
            throw HealthPatternStoreError.loadFailed
        }
    }
    
    func getPatterns(for healthIssues: [HealthIssue]) async throws -> [HealthPattern] {
        let patterns = try await getPatterns()
        return patterns.filter { healthIssues.contains($0.healthIssue) }
    }
} 