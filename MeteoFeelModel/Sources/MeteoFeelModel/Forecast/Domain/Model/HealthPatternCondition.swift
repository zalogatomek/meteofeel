import Foundation

public enum HealthPatternCondition: String, Codable, Equatable, Sendable {
    case above
    case below
    case rapidIncrease
    case rapidDecrease
    case equals
} 