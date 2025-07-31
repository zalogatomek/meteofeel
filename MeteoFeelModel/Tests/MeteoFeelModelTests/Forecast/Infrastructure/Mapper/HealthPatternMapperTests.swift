import Foundation
import Testing
@testable import MeteoFeelModel

final class HealthPatternMapperTests {
    
    // MARK: - Tests - Successful Mapping
    
    @Test
    func mapsResponseWithBothThresholds() throws {
        let response = HealthPatternResponse.createStub(
            patterns: [
                .createStub(
                    healthIssue: .headache,
                    parameter: .temperature,
                    condition: .above,
                    thresholds: .createStub(high: 30.0, medium: 25.0)
                )
            ]
        )
        
        let result = HealthPatternMapper.map(response)
        
        try #require(result.count == 2)
        
        let highRiskPattern = try #require(result.first { $0.risk == .high })
        let mediumRiskPattern = try #require(result.first { $0.risk == .medium })
        
        #expect(highRiskPattern.healthIssue == .headache)
        #expect(highRiskPattern.condition == .above)
        #expect(highRiskPattern.value.parameter == .temperature)
        #expect(highRiskPattern.value.value == 30.0)
        
        #expect(mediumRiskPattern.healthIssue == .headache)
        #expect(mediumRiskPattern.condition == .above)
        #expect(mediumRiskPattern.value.parameter == .temperature)
        #expect(mediumRiskPattern.value.value == 25.0)
    }
    
    @Test(arguments: [
        ([HealthPatternResponse.HealthPattern.createStub(thresholds: .createStub(high: 30.0, medium: nil))], HealthRisk.high),
        ([HealthPatternResponse.HealthPattern.createStub(thresholds: .createStub(high: nil, medium: 30.0))], HealthRisk.medium)
    ])
    func mapsResponseWithSingleThreshold(patterns: [HealthPatternResponse.HealthPattern], risk: HealthRisk) throws {
        let response: HealthPatternResponse = HealthPatternResponse.createStub(patterns: patterns)
        
        let result = try #require(HealthPatternMapper.map(response).first)
        
        #expect(result.risk == risk)
    }
    
    // MARK: - Tests - Missing Data Handling
    
    @Test(arguments: [
        nil, 
        [HealthPatternResponse.HealthPattern]()
    ])
    func returnsEmptyArrayWhenPatternsIsNilOrEmpty(patterns: [HealthPatternResponse.HealthPattern]?) throws {
        let response = HealthPatternResponse.createStub(patterns: patterns)
        
        let result = HealthPatternMapper.map(response)
        
        #expect(result.isEmpty)
    }
    
    @Test(arguments: [
        [HealthPatternResponse.HealthPattern.createStub(healthIssue: nil)],
        [HealthPatternResponse.HealthPattern.createStub(parameter: nil)],
        [HealthPatternResponse.HealthPattern.createStub(condition: nil)],
        [HealthPatternResponse.HealthPattern.createStub(thresholds: .createStub(high: nil, medium: nil))],
    ])
    func returnsEmptyArrayWhenMissingRequiredFields(patterns: [HealthPatternResponse.HealthPattern]) throws {
        let response = HealthPatternResponse.createStub(patterns: patterns)
        
        let result = HealthPatternMapper.map(response)
        
        #expect(result.isEmpty)
    }
} 
