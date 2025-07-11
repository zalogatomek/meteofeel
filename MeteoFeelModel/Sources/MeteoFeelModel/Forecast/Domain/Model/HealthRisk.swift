import Foundation

public enum HealthRisk: String, Codable, Comparable, Sendable {
    case medium
    case high

    public static func < (lhs: HealthRisk, rhs: HealthRisk) -> Bool {
        switch (lhs, rhs) {
        case (.medium, .high): true
        case (.high, .medium): false
        case (.medium, .medium): false
        case (.high, .high): false
        }
    }
} 