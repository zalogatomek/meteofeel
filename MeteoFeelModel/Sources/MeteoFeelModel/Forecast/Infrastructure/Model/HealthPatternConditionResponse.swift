import Foundation
import MeteoFeelUtilities

enum HealthPatternConditionResponse: String, EnumerationResponse {
    case above
    case below
    case rapidIncrease
    case rapidDecrease
    case equals
    case unknown
    
    static var defaultCase: Self { .unknown }
} 