public import Foundation

public class MockUserDefaults: UserDefaults, @unchecked Sendable {

    // MARK: - Properties

    private var storage: [String: Any] = [:]

    // MARK: - Lifecycle
    
    public override func data(forKey defaultName: String) -> Data? {
        return storage[defaultName] as? Data
    }
    
    public override func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }
    
    public override func removeObject(forKey defaultName: String) {
        storage.removeValue(forKey: defaultName)
    }
} 
