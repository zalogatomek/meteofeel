import Foundation
import Testing
@testable import MeteoFeelModel

struct LocationTests {

    // MARK: - Tests
    
    @Test func initWithValidLocation() throws {
        let coordinates = Coordinates(latitude: 40.7128, longitude: -74.0060)
        let location = Location(name: "New York", coordinates: coordinates)
        
        #expect(location.name == "New York")
        #expect(location.coordinates == coordinates)
    }
    
    @Test(arguments: [
        Coordinates(latitude: 40.7128, longitude: -74.0060),
        Coordinates(latitude: 40.7128 + 0.000009, longitude: -74.0060), // ~1 meter north
        Coordinates(latitude: 40.7128 + 0.00008, longitude: -74.0060), // ~9 meters north
        Coordinates(latitude: 40.7128 + 0.00006, longitude: -74.0060 + 0.00006) // ~6.7 meters north and east, diagonal distance ~9.5 meters
    ])
    func equalLocationsWithSameNameAndCloseCoordinates(_ coordinates: Coordinates) throws {
        let location1 = Location(name: "New York", coordinates: Coordinates(latitude: 40.7128, longitude: -74.0060))
        let location2 = Location(name: "New York", coordinates: coordinates)
        
        #expect(location1 == location2)
    }
    
    @Test func notEqualLocationsWithDifferentNames() throws {
        let coordinates = Coordinates(latitude: 40.7128, longitude: -74.0060)
        let location1 = Location(name: "New York", coordinates: coordinates)
        let location2 = Location(name: "Los Angeles", coordinates: coordinates)
        
        #expect(location1 != location2)
    }
    
    @Test func notEqualLocationsWithSameNameButFarCoordinates() throws {
        let coordinates1 = Coordinates(latitude: 40.7128, longitude: -74.0060)
        let coordinates2 = Coordinates(latitude: 40.7128 + 0.0001, longitude: -74.0060) // ~11 meters north
        
        let location1 = Location(name: "New York", coordinates: coordinates1)
        let location2 = Location(name: "New York", coordinates: coordinates2)
        
        #expect(location1 != location2)
    }
    
    @Test func notEqualLocationsWithDifferentNamesAndFarCoordinates() throws {
        let coordinates1 = Coordinates(latitude: 40.7128, longitude: -74.0060)
        let coordinates2 = Coordinates(latitude: 40.7128 + 0.0001, longitude: -74.0060) // ~11 meters north
        
        let location1 = Location(name: "New York", coordinates: coordinates1)
        let location2 = Location(name: "Los Angeles", coordinates: coordinates2)
        
        #expect(location1 != location2)
    }
} 