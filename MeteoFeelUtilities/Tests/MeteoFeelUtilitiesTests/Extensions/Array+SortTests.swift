import Foundation
import Testing
@testable import MeteoFeelUtilities

struct ArraySortTests {

    // MARK: - Tests - sortedByDescription()
    
    @Test 
    func sortedByDescriptionWithStrings() throws {
        let array = ["zebra", "apple", "banana", "cherry"]
        let sortedArray = array.sortedByDescription()
        
        #expect(sortedArray == ["apple", "banana", "cherry", "zebra"])
    }
    
    @Test 
    func sortedByDescriptionWithCustomObjects() throws {
        struct CustomString: CustomStringConvertible {
            let value: String
            var description: String { value }
        }
        
        let items = [
            CustomString(value: "zebra"),
            CustomString(value: "apple"),
            CustomString(value: "banana"),
            CustomString(value: "cherry")
        ]
        
        let sortedArray = items.sortedByDescription()
        
        #expect(sortedArray.map(\.description) == ["apple", "banana", "cherry", "zebra"])
    }
    
    @Test 
    func sortedByDescriptionWithEmptyArray() throws {
        let array: [String] = []
        let sortedArray = array.sortedByDescription()
        
        #expect(sortedArray.isEmpty)
    }
    
    @Test 
    func sortedByDescriptionWithSingleElement() throws {
        let array = ["apple"]
        let sortedArray = array.sortedByDescription()
        
        #expect(sortedArray == array)
    }
    
    @Test 
    func sortedByDescriptionWithAlreadySorted() throws {
        let array = ["apple", "banana", "cherry"]
        let sortedArray = array.sortedByDescription()
        
        #expect(sortedArray == array)
    }
    
    @Test 
    func sortedByDescriptionWithDuplicates() throws {
        let array = ["zebra", "apple", "banana", "apple", "cherry"]
        let sortedArray = array.sortedByDescription()
        
        #expect(sortedArray == ["apple", "apple", "banana", "cherry", "zebra"])
    }
    
    @Test 
    func sortedByDescriptionWithCaseSensitive() throws {
        let array = ["Zebra", "apple", "Banana", "cherry"]
        let sortedArray = array.sortedByDescription()
        
        #expect(sortedArray == ["apple", "Banana", "cherry", "Zebra"])
    }
} 