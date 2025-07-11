import SwiftUI
import MeteoFeelModel

extension HealthRisk {
    
    var displayName: String {
        switch self {
        case .medium: "Medium"
        case .high: "High"
        }
    }
    
    var color: Color {
        switch self {
        case .medium: .orange
        case .high: .red
        }
    }
} 