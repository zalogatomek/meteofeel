import Foundation
import Testing
@testable import MeteoFeelModel

struct HealthAlertTests {

    // MARK: - Tests
    
    @Test 
    func comparesByHealthIssueFirst() throws {
        let headacheAlert = HealthAlert.createStub(
            healthIssue: .headache,
            risk: .high
        )
        
        let jointPainAlert = HealthAlert.createStub(
            healthIssue: .jointPain,
            risk: .medium
        )
        
        #expect(headacheAlert < jointPainAlert)
        #expect(jointPainAlert > headacheAlert)
    }
    
    @Test 
    func comparesByRiskWhenHealthIssueSame() throws {
        let mediumRiskAlert = HealthAlert.createStub(
            healthIssue: .headache,
            risk: .medium
        )
        
        let highRiskAlert = HealthAlert.createStub(
            healthIssue: .headache,
            risk: .high
        )
        
        #expect(highRiskAlert < mediumRiskAlert)
        #expect(mediumRiskAlert > highRiskAlert)
    }
    
    @Test 
    func comparesByParameterWhenHealthIssueAndRiskSame() throws {
        let temperatureAlert = HealthAlert.createStub(
            healthIssue: .headache,
            parameter: .temperature,
            value: 25.0,
            risk: .medium
        )
        
        let humidityAlert = HealthAlert.createStub(
            healthIssue: .headache,
            parameter: .humidity,
            value: 80.0,
            risk: .medium
        )
        
        #expect(temperatureAlert < humidityAlert)
        #expect(humidityAlert > temperatureAlert)
    }
    
    @Test 
    func comparesEqualWhenAllPropertiesSame() throws {
        let alert1 = HealthAlert.createStub()
        let alert2 = HealthAlert.createStub()
        
        #expect(alert1 == alert2)
    }
} 
