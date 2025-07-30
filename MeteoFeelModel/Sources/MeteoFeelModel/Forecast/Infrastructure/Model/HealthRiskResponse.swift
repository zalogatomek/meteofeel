import Foundation
import MeteoFeelUtilities

enum HealthRiskResponse: String, EnumerationResponse {
    case medium
    case high
    case unknown
    
    static var defaultCase: Self { .unknown }
} 