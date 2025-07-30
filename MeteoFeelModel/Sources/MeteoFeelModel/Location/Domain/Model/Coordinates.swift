import Foundation

public struct Coordinates: Codable, Equatable, Sendable {

    // MARK: - Constants
    
    /// Average latitude degrees equivalent to 1 meter (approximately 0.000009 degrees)
    private static let latitudeDegreesPerMeter: Double = 0.000009
    /// Average longitude degrees equivalent to 1 meter (varies by latitude, using approximate value)
    private static let longitudeDegreesPerMeter: Double = 0.000009
    
    // MARK: - Properties

    public let latitude: Double
    public let longitude: Double

    // MARK: - Lifecycle

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // MARK: - Distance
    
    /// Calculates the distance in meters from this coordinate to another coordinate
    /// Uses a naive approach with fixed degree-to-meter conversion
    /// Note: This is an approximation and may not be accurate for all latitudes
    public func distance(from other: Coordinates) -> Double {
        let latDifference = abs(latitude - other.latitude)
        let lonDifference = abs(longitude - other.longitude)
        
        let latMeters = latDifference / Self.latitudeDegreesPerMeter
        let lonMeters = lonDifference / Self.longitudeDegreesPerMeter
        
        // Use Euclidean distance for simplicity
        return sqrt(latMeters * latMeters + lonMeters * lonMeters)
    }
    
    /// Checks if this coordinate is within the specified distance (in meters) from another coordinate
    /// Uses a naive approach with fixed degree-to-meter conversion
    /// Note: This is an approximation and may not be accurate for all latitudes
    public func isWithin(meters: Int, from other: Coordinates) -> Bool {
        return distance(from: other) <= Double(meters)
    }
}
