import Foundation

enum HealthIssueResponse: String, EnumerationResponse {
    case headache
    case jointPain
    case respiratory
    case fatigue
    case allergy
    case asthma
    case mood
    case cardiovascular
    case skin
    case unknown
    
    static var defaultCase: Self { .unknown }
} 