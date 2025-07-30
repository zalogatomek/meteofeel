import Foundation
import Testing
@testable import MeteoFeelModel

struct CoordinatesTests {

    // MARK: - Tests

    @Test func distanceFromSameCoordinates() throws {
        let coordinates = Coordinates(latitude: 40.7128, longitude: -74.0060)
        
        #expect(coordinates.distance(from: coordinates) == 0.0)
    }
    
    @Test func distanceFromCloseCoordinates() throws {
        let base = Coordinates(latitude: 40.7128, longitude: -74.0060)
        let close = Coordinates(latitude: 40.7128 + 0.000009, longitude: -74.0060) // ~1 meter north
        
        let distance = base.distance(from: close)
        #expect(distance > 0.9 && distance < 1.1) // Approximately 1 meter
    }
    
    @Test func distanceFromDiagonalCoordinates() throws {
        let base = Coordinates(latitude: 40.7128, longitude: -74.0060)
        let diagonal = Coordinates(
            latitude: 40.7128 + 0.000009, // ~1 meter north
            longitude: -74.0060 + 0.000009 // ~1 meter east
        )
        
        let distance = base.distance(from: diagonal)
        // Diagonal distance should be ~1.414 meters (sqrt(1² + 1²))
        #expect(distance > 1.3 && distance < 1.5)
    }
    
    @Test func distanceFromFarCoordinates() throws {
        let base = Coordinates(latitude: 40.7128, longitude: -74.0060)
        let far = Coordinates(latitude: 40.7128 + 0.0001, longitude: -74.0060) // ~11 meters north
        
        let distance = base.distance(from: far)
        #expect(distance > 10.0 && distance < 12.0) // Approximately 11 meters
    }
    
    @Test func isWithinSameCoordinates() throws {
        let coordinates = Coordinates(latitude: 40.7128, longitude: -74.0060)
        
        #expect(coordinates.isWithin(meters: 0, from: coordinates))
        #expect(coordinates.isWithin(meters: 1, from: coordinates))
        #expect(coordinates.isWithin(meters: 10, from: coordinates))
    }
    
    @Test func isWithinCloseCoordinates() throws {
        let base = Coordinates(latitude: 40.7128, longitude: -74.0060)
        let close = Coordinates(latitude: 40.7128 + 0.000009, longitude: -74.0060) // ~1 meter north
        
        #expect(!base.isWithin(meters: 0, from: close))
        #expect(base.isWithin(meters: 1, from: close))
        #expect(base.isWithin(meters: 2, from: close))
    }
    
    @Test func isWithinFarCoordinates() throws {
        let base = Coordinates(latitude: 40.7128, longitude: -74.0060)
        let far = Coordinates(latitude: 40.7128 + 0.0001, longitude: -74.0060) // ~11 meters north
        
        #expect(!base.isWithin(meters: 1, from: far))
        #expect(!base.isWithin(meters: 10, from: far))
        #expect(base.isWithin(meters: 15, from: far))
    }
    
    @Test func isWithinDiagonalDistance() throws {
        let base = Coordinates(latitude: 40.7128, longitude: -74.0060)
        let diagonal = Coordinates(
            latitude: 40.7128 + 0.000009, // ~1 meter north
            longitude: -74.0060 + 0.000009 // ~1 meter east
        )
        
        // Diagonal distance should be ~1.414 meters (sqrt(1² + 1²))
        #expect(!base.isWithin(meters: 1, from: diagonal))
        #expect(base.isWithin(meters: 2, from: diagonal))
    }
    
    @Test func isWithinNegativeCoordinates() throws {
        let base = Coordinates(latitude: -40.7128, longitude: -74.0060)
        let close = Coordinates(latitude: -40.7128 + 0.000009, longitude: -74.0060)
        
        #expect(base.isWithin(meters: 1, from: close))
    }
    
    @Test func isWithinLargeDistance() throws {
        let base = Coordinates(latitude: 40.7128, longitude: -74.0060)
        let far = Coordinates(latitude: 40.7128 + 0.001, longitude: -74.0060) // ~111 meters
        
        #expect(!base.isWithin(meters: 100, from: far))
        #expect(base.isWithin(meters: 120, from: far))
    }
} 