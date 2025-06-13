import Foundation

public struct Location: Codable, Equatable {
    public let id: UUID
    public let name: String
    public let coordinates: Coordinates
    public let timeZone: TimeZone
    
    public init(
        id: UUID = UUID(),
        name: String,
        coordinates: Coordinates,
        timeZone: TimeZone
    ) {
        self.id = id
        self.name = name
        self.coordinates = coordinates
        self.timeZone = timeZone
    }
}

public struct Coordinates: Codable, Equatable {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
} 