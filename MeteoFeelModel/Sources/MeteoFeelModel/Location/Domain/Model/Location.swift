import Foundation

public struct Location: Codable, Equatable, Sendable {

    // MARK: - Properties

    public let name: String
    public let coordinates: Coordinates

    // MARK: - Lifecycle

    public init(
        name: String,
        coordinates: Coordinates
    ) {
        self.name = name
        self.coordinates = coordinates
    }
    
    // MARK: - Equatable
    
    public static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.name == rhs.name && lhs.coordinates.isWithin(meters: 10, from: rhs.coordinates)
    }
}

extension Location {
    
    // MARK: - Stubs
    
    public static func createStub(
        name: String = "City",
        coordinates: Coordinates = Coordinates.createStub()
    ) -> Location {
        return Location(
            name: name,
            coordinates: coordinates
        )
    }
}
