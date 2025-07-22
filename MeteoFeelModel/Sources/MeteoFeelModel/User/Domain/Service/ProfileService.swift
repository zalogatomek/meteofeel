import Foundation

public enum ProfileServiceError: Error {
    case saveError
    case loadError
    case invalidData
}

public protocol ProfileServiceProtocol: Sendable {
    func loadProfile() async -> UserProfile?
    func saveProfile(_ profile: UserProfile) async throws
}

final class ProfileService: ProfileServiceProtocol {

    // MARK: - Properties

    private let profileStore: ProfileStoreProtocol

    // MARK: - Lifecycle
    
    init(profileStore: ProfileStoreProtocol) {
        self.profileStore = profileStore
    }

    // MARK: - ProfileServiceProtocol
    
    func loadProfile() async -> UserProfile? {
        await profileStore.loadProfile()
    }
    
    func saveProfile(_ profile: UserProfile) async throws {
        do {
            try await profileStore.saveProfile(profile)
        } catch {
            throw ProfileServiceError.saveError
        }
    }
} 