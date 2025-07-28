public import Foundation

public struct Location: Codable, Equatable, Sendable {
    public let id: UUID
    public let name: String
    public let coordinates: Coordinates
    
    public init(
        id: UUID = UUID(),
        name: String,
        coordinates: Coordinates
    ) {
        self.id = id
        self.name = name
        self.coordinates = coordinates
    }
}
