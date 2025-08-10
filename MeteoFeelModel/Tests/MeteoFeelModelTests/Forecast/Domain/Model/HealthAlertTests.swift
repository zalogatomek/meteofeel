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
    
    // MARK: - Array Grouping Tests
    
    @Test
    func groupByHealthIssueWithEmptyArray() throws {
        let alerts: [HealthAlert] = []
        let grouped = alerts.groupByHealthIssue()
        
        #expect(grouped.isEmpty)
    }
    
    @Test
    func groupByHealthIssueWithSingleAlert() throws {
        let alert = HealthAlert.createStub(healthIssue: .headache)
        let alerts = [alert]
        let grouped = alerts.groupByHealthIssue()
        
        #expect(grouped.count == 1)
        #expect(grouped[.headache]?.count == 1)
        #expect(grouped[.headache]?.first == alert)
    }
    
    @Test
    func groupByHealthIssueWithMultipleDifferentIssues() throws {
        let headacheAlert = HealthAlert.createStub(healthIssue: .headache)
        let fatigueAlert = HealthAlert.createStub(healthIssue: .fatigue)
        let respiratoryAlert = HealthAlert.createStub(healthIssue: .respiratory)
        
        let alerts = [headacheAlert, fatigueAlert, respiratoryAlert]
        let grouped = alerts.groupByHealthIssue()
        
        #expect(grouped.count == 3)
        #expect(grouped[.headache]?.count == 1)
        #expect(grouped[.fatigue]?.count == 1)
        #expect(grouped[.respiratory]?.count == 1)
        #expect(grouped[.headache]?.first == headacheAlert)
        #expect(grouped[.fatigue]?.first == fatigueAlert)
        #expect(grouped[.respiratory]?.first == respiratoryAlert)
    }
    
    @Test
    func groupByHealthIssueWithMultipleAlertsForSameIssue() throws {
        let headacheAlert1 = HealthAlert.createStub(
            healthIssue: .headache,
            parameter: .temperature,
            risk: .high
        )
        let headacheAlert2 = HealthAlert.createStub(
            healthIssue: .headache,
            parameter: .pressure,
            risk: .medium
        )
        let fatigueAlert = HealthAlert.createStub(healthIssue: .fatigue)
        
        let alerts = [headacheAlert1, headacheAlert2, fatigueAlert]
        let grouped = alerts.groupByHealthIssue()
        
        #expect(grouped.count == 2)
        #expect(grouped[.headache]?.count == 2)
        #expect(grouped[.fatigue]?.count == 1)
        #expect(grouped[.headache]?.contains(headacheAlert1) == true)
        #expect(grouped[.headache]?.contains(headacheAlert2) == true)
        #expect(grouped[.fatigue]?.first == fatigueAlert)
    }
    
    @Test
    func groupByHealthIssueWithAllAlertsForSameIssue() throws {
        let headacheAlert1 = HealthAlert.createStub(
            healthIssue: .headache,
            parameter: .temperature,
            risk: .high
        )
        let headacheAlert2 = HealthAlert.createStub(
            healthIssue: .headache,
            parameter: .pressure,
            risk: .medium
        )
        let headacheAlert3 = HealthAlert.createStub(
            healthIssue: .headache,
            parameter: .humidity,
            risk: .medium
        )
        
        let alerts = [headacheAlert1, headacheAlert2, headacheAlert3]
        let grouped = alerts.groupByHealthIssue()
        
        #expect(grouped.count == 1)
        #expect(grouped[.headache]?.count == 3)
        #expect(grouped[.headache]?.contains(headacheAlert1) == true)
        #expect(grouped[.headache]?.contains(headacheAlert2) == true)
        #expect(grouped[.headache]?.contains(headacheAlert3) == true)
    }
    
    @Test
    func groupByHealthIssuePreservesAlertOrderWithinGroups() throws {
        let headacheAlert1 = HealthAlert.createStub(
            healthIssue: .headache,
            parameter: .temperature,
            risk: .high
        )
        let headacheAlert2 = HealthAlert.createStub(
            healthIssue: .headache,
            parameter: .pressure,
            risk: .medium
        )
        let headacheAlert3 = HealthAlert.createStub(
            healthIssue: .headache,
            parameter: .humidity,
            risk: .medium
        )
        
        let alerts = [headacheAlert1, headacheAlert2, headacheAlert3]
        let grouped = alerts.groupByHealthIssue()
        let headacheGroup = grouped[.headache] ?? []
        
        #expect(headacheGroup.count == 3)
        #expect(headacheGroup[0] == headacheAlert1)
        #expect(headacheGroup[1] == headacheAlert2)
        #expect(headacheGroup[2] == headacheAlert3)
    }
} 
