import Foundation

public enum ProfileServiceError: Error {
    case saveError
    case loadError
    case invalidData
}

protocol ProfileServiceProtocol: Sendable {
    func loadProfile() async -> UserProfile?
    func saveProfile(_ profile: UserProfile) async throws
    func updateUserName(_ name: String) async throws
    func updateUserLocation(_ location: Location) async throws
    func updateHealthIssues(_ healthIssues: Set<HealthIssue>) async throws
    func setHealthIssue(_ healthIssue: HealthIssue, isSelected: Bool) async throws
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
    
    func updateUserName(_ name: String) async throws {
        guard let currentProfile = await loadProfile() else { throw ProfileServiceError.loadError }
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty
        let updatedProfile = currentProfile.bySettingName(trimmedName)
        try await saveProfile(updatedProfile)
    }
    
    func updateUserLocation(_ location: Location) async throws {
        guard let currentProfile = await loadProfile() else { throw ProfileServiceError.loadError }
        let updatedProfile = currentProfile.bySettingLocation(location)
        try await saveProfile(updatedProfile)
    }
    
    func updateHealthIssues(_ healthIssues: Set<HealthIssue>) async throws {
        guard let currentProfile = await loadProfile() else { throw ProfileServiceError.loadError }
        let updatedProfile = currentProfile.bySettingHealthIssues(healthIssues)
        try await saveProfile(updatedProfile)
    }
    
    func setHealthIssue(_ healthIssue: HealthIssue, isSelected: Bool) async throws {
        guard let currentProfile = await loadProfile() else { throw ProfileServiceError.loadError }
        var updatedHealthIssues = currentProfile.healthIssues
        if isSelected {
            updatedHealthIssues.insert(healthIssue)
        } else {
            updatedHealthIssues.remove(healthIssue)
        }
        let updatedProfile = currentProfile.bySettingHealthIssues(updatedHealthIssues)
        try await saveProfile(updatedProfile)
    }
} 