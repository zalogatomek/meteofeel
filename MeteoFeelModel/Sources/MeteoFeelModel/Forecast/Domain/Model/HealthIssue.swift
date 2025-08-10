import Foundation

public enum HealthIssue: String, Codable, Hashable, Comparable, CaseIterable, Sendable {
    case headache
    case jointPain
    case respiratory
    case fatigue
    case mood
    case allergy
    case asthma
    case cardiovascular
    case skin

    // MARK: - Comparable

    public static func < (lhs: HealthIssue, rhs: HealthIssue) -> Bool {
        HealthIssue.allCases.firstIndex(of: lhs) ?? .zero < HealthIssue.allCases.firstIndex(of: rhs) ?? .zero
    }
} 
