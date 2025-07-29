import Foundation

public final class ProfileServiceFactory {

    // MARK: - Create

    public static func create() -> any ProfileServiceProtocol {
        let profileStore = ProfileStore()
        return ProfileService(profileStore: profileStore)
    }
} 
