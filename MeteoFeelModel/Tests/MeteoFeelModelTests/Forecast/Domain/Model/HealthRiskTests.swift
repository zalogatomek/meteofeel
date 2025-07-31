import Foundation
import Testing
@testable import MeteoFeelModel

struct HealthRiskTests {

    // MARK: - Tests
    
    @Test 
    func comparesCorrectly() throws {
        #expect(HealthRisk.medium < HealthRisk.high)
        #expect(HealthRisk.high > HealthRisk.medium)
        #expect(HealthRisk.medium == HealthRisk.medium)
        #expect(HealthRisk.high == HealthRisk.high)
    }
} 
