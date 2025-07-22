import Foundation
import MeteoFeelModel

extension DeviceLocationError: @retroactive LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Location permission was denied. Please enable location access in Settings."
        case .locationUnavailable:
            return "Unable to determine your current location. Please try again."
        case .geocodingFailed:
            return "Failed to get location details. Please try again."
        }
    }
} 
