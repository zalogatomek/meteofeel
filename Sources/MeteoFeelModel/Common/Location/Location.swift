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