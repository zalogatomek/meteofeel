import Foundation

public protocol DeviceLocationServiceProtocol: Sendable {
    func getDeviceLocation() async throws -> Location
}

public enum DeviceLocationError: Error {
    case permissionDenied
    case locationUnavailable
    case geocodingFailed
} 
