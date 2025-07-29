import Foundation
import Testing
@testable import MeteoFeelModel

struct TimeOfDayTests {

    // MARK: - Tests
    
    @Test func comparesCorrectly() throws {
        #expect(TimeOfDay.morning == TimeOfDay.morning)
        #expect(TimeOfDay.morning < TimeOfDay.afternoon)
        #expect(TimeOfDay.morning < TimeOfDay.evening)
        #expect(TimeOfDay.afternoon < TimeOfDay.evening)
    }
} 