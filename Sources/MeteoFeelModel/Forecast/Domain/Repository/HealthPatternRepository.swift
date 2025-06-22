import Foundation

protocol HealthPatternRepositoryProtocol {
    func savePatterns(_ patterns: [HealthPattern]) async throws
    func getPatterns(for healthIssues: [HealthIssue]) async throws -> [HealthPattern]
} 