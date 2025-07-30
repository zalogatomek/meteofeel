import Foundation
import Testing
@testable import MeteoFeelUtilities

struct ArrayUniqueTests {

    // MARK: - Helpers

    private struct Person: CustomStringConvertible {
        let id: Int
        let name: String
        var description: String { name }
    }

    private let people = [
        Person(id: 1, name: "Alice"),
        Person(id: 2, name: "Bob"),
        Person(id: 3, name: "Alice"), // Same name, different ID
        Person(id: 4, name: "Charlie")
    ]

    // MARK: - Tests - unique()
    
    @Test func unique() throws {
        let array = [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]
        let uniqueArray = array.unique()
        
        #expect(uniqueArray == [1, 2, 3, 4])
    }
    
    @Test func uniqueWithNoDuplicates() throws {
        let array = [1, 2, 3, 4, 5]
        let uniqueArray = array.unique()
        
        #expect(uniqueArray == array)
    }
    
    @Test func uniqueWithAllDuplicates() throws {
        let array = [1, 1, 1, 1, 1]
        let uniqueArray = array.unique()
        
        #expect(uniqueArray == [1])
    }
    
    // MARK: - Tests - unique(by:)
    
    @Test func uniqueByKeyPath() throws {
        let uniqueByName = people.unique(by: \.name)
        
        #expect(uniqueByName.map(\.name) == ["Alice", "Bob", "Charlie"])
    }
    
    // MARK: - Tests - uniqueByDescription()
    
    @Test func uniqueByDescription() throws {
        let uniqueArray = people.uniqueByDescription()

        #expect(uniqueArray.map(\.name) == ["Alice", "Bob", "Charlie"])
    }
} 