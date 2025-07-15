import Foundation

protocol ProfileStoreProtocol: Sendable {
    func loadProfile() async -> UserProfile?
    func saveProfile(_ profile: UserProfile) async throws
}

actor ProfileStore: ProfileStoreProtocol {

    // MARK: - Keys

    enum Keys {
        static let profile = "user_profile"
    }

    // MARK: - Properties

    private let userDefaults: UserDefaults

    // MARK: - Lifecycle
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func loadProfile() async -> UserProfile? {
        guard let data = userDefaults.data(forKey: Keys.profile) else { return nil }
        return try? JSONDecoder().decode(UserProfile.self, from: data)
    }
    
    func saveProfile(_ profile: UserProfile) async throws {
        do {
            let data = try JSONEncoder().encode(profile)
            userDefaults.set(data, forKey: Keys.profile)
        } catch {
            throw ProfileServiceError.saveError
        }
    }
} 