import Foundation

public struct Coordinates: Codable, Equatable {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    // MARK: - Static Helpers

    static var gliwiceAirport: Coordinates {
        Coordinates(latitude: 50.2687, longitude: 18.6725)
    }
}
