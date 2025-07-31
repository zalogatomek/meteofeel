import Foundation
import Testing
@testable import MeteoFeelModel

struct HealthIssueTests {

    // MARK: - Tests
    
    @Test 
    func comparesByAllCasesOrder() throws {
        let allCases = HealthIssue.allCases
        
        for i in 0..<(allCases.count - 1) {
            #expect(allCases[i] < allCases[i + 1])
            #expect(allCases[i + 1] > allCases[i])
        }
    }
} 
