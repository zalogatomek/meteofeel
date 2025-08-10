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
    
    var systemIconName: String {
        switch self {
        case .headache: "brain.head.profile"
        case .jointPain: "figure.walk"
        case .respiratory: "lungs"
        case .fatigue: "bed.double"
        case .allergy: "leaf"
        case .asthma: "lungs"
        case .mood: "face.dashed"
        case .cardiovascular: "heart"
        case .skin: "hand.raised"
        }
    }
} 
