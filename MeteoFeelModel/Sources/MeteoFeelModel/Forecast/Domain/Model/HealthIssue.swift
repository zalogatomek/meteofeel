import Foundation

public enum HealthIssue: String, Codable, Equatable, CaseIterable, Sendable {
    case headache
    case jointPain
    case respiratory
    case fatigue
    case allergy
    case asthma
    case mood
    case cardiovascular
    case skin
} 