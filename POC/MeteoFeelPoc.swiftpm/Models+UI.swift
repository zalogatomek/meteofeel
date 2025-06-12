import SwiftUI

// MARK: - WellBeingLevel

extension WellBeingLevel {
    var color: Color {
        switch self {
        case .good: .green
        case .moderate: .orange
        case .poor: .red
        }
    }
    
    var icon: String {
        switch self {
        case .good: "checkmark.circle.fill"
        case .moderate: "exclamationmark.circle.fill"
        case .poor: "exclamationmark.triangle.fill"
        }
    }
    
    var label: String {
        switch self {
        case .good: "Good"
        case .moderate: "Moderate"
        case .poor: "Poor"
        }
    }
}

// MARK: - AlertSeverity

extension AlertSeverity {
    var color: Color {
        switch self {
        case .low: .green
        case .medium: .orange
        case .high: .red
        }
    }
} 