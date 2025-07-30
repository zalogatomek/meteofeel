import Foundation
import Testing
@testable import MeteoFeelUtilities

struct StringEmptyTests {

    // MARK: - Tests - nilIfEmpty
    
    @Test(arguments: [
        ""
    ])
    func nilIfEmptyWithEmptyString(_ string: String) throws {
        #expect(string.nilIfEmpty == nil)
    }
    
    @Test(arguments: [
        "a",
        "🚀🌟✨",
        "Hello, World!",
        "   "
    ])
    func nilIfEmptyWithNonEmptyString(_ string: String) throws {
        #expect(string.nilIfEmpty == string)
    }
} 
