import Foundation
import Testing
@testable import MeteoFeelUtilities

struct EnumerationResponseTests {

    // MARK: - Helpers
    
    enum TestEnum: String, EnumerationResponse, CaseIterable {
        case first = "first"
        case second = "second"
        case third = "third"
        case unknown = "unknown"
        
        static var defaultCase: TestEnum { .unknown }
    }

    // MARK: - Tests - init
    
    @Test(arguments: [
        "first",
        "second",
        "third",
        "FIRST",
        "Second",
        "THIRD"
    ])
    func initWithValidRawValue(_ value: String) throws {
        let enumValue = TestEnum(rawValue: value)   

        #expect(enumValue != .unknown)
        #expect(enumValue.rawValue == value.lowercased())
    }
    
    @Test(arguments: [
        "invalid",
        "nonexistent",
        "wrong"
    ])
    func initWithInvalidRawValue(_ value: String) throws {
        let enumValue = TestEnum(rawValue: value)
        
        #expect(enumValue == .unknown)
    }
    
    // MARK: - Tests - caseFor
    
    @Test(arguments: [
        ("first", TestEnum.first),
        ("second", .second),
        ("third", .third),
        ("FIRST", .first),
        ("Second", .second),
        ("THIRD", .third),
        ("unknown", .unknown)
    ])
    func caseForWithValidStringRawValue(value: String, expected: TestEnum) throws {
        let caseValue = TestEnum.caseFor(value)
        
        #expect(caseValue == expected)
    }
    
    @Test(arguments: ["invalid", "nonexistent", "wrong"])
    func caseForWithInvalidStringRawValue(_ value: String) throws {
        let caseValue = TestEnum.caseFor(value)
        
        #expect(caseValue == nil)
    }
    
    // MARK: - Tests - defaultCase
    
    @Test 
    func defaultCaseReturnsUnknown() throws {
        #expect(TestEnum.defaultCase == .unknown)
    }
} 
