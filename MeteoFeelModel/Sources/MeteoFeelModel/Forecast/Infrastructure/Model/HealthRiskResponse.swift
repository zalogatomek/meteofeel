import Foundation

enum HealthRiskResponse: String, EnumerationResponse {
    case medium
    case high
    case unknown
    
    static var defaultCase: Self { .unknown }
} 