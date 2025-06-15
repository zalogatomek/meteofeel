import Foundation

public enum TimeOfDay: String, Codable, Hashable, Comparable {
    case morning
    case afternoon
    case evening
    
    public static func < (lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
        switch (lhs, rhs) {
        case (.morning, .afternoon), (.morning, .evening), (.afternoon, .evening):
            return true
        default:
            return false
        }
    }
} 