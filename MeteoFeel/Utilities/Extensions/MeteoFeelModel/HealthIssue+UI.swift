import Foundation
import MeteoFeelModel

extension HealthIssue {
    
    var displayName: String {
        switch self {
        case .headache: "Headache"
        case .jointPain: "Joint Pain"
        case .respiratory: "Respiratory Issues"
        case .fatigue: "Fatigue"
        case .allergy: "Allergy"
        case .asthma: "Asthma"
        case .mood: "Mood Changes"
        case .cardiovascular: "Cardiovascular"
        case .skin: "Skin Issues"
        }
    }
} 