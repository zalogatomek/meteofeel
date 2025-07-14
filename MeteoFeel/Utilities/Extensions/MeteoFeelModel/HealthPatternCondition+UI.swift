import Foundation
import MeteoFeelModel

extension HealthPatternCondition {
    
    var displayText: String? {
        switch self {
        case .above: "high"
        case .below: "low"
        case .rapidIncrease: "rapidly increasing"
        case .rapidDecrease: "rapidly decreasing"
        case .equals: nil
        }
    }
} 