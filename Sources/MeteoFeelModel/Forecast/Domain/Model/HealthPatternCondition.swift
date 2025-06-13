import Foundation

public enum HealthPatternCondition: String, Codable, Equatable {
    case above
    case below
    case rapidIncrease
    case rapidDecrease
    case equals
} 