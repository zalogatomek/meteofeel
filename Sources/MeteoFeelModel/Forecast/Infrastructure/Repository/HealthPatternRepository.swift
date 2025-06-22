import Foundation

enum HealthPatternRepositoryError: Error {
    case saveFailed
    case loadFailed
    case invalidData
}

final class HealthPatternRepository: HealthPatternRepositoryProtocol {
    
    // MARK: - Keys
    
    private enum Keys {
        static let patterns = "health_patterns"
    }
    
    // MARK: - Properties
    
    private let defaults: UserDefaults
    
    // MARK: - Lifecycle
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    // MARK: - Save
    
    func savePatterns(_ patterns: [HealthPattern]) async throws {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(patterns)
            defaults.set(data, forKey: Keys.patterns)
        } catch {
            throw HealthPatternRepositoryError.saveFailed
        }
    }
    
    // MARK: - Get
    
    func getPatterns() async throws -> [HealthPattern] {
        guard let data = defaults.data(forKey: Keys.patterns) else { return [] }
        
        do {
            return try JSONDecoder().decode([HealthPattern].self, from: data)
        } catch {
            throw HealthPatternRepositoryError.loadFailed
        }
    }
    
    func getPatterns(for healthIssues: [HealthIssue]) async throws -> [HealthPattern] {
        let patterns = try await getPatterns()
        return patterns.filter { healthIssues.contains($0.healthIssue) }
    }
} 