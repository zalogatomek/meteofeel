import Foundation

final class ProfileStateObservableFactory {
    static func create() -> ProfileStateObservable {
        let profileStore = ProfileStore()
        let profileService = ProfileService(profileStore: profileStore)
        return ProfileStateObservable(profileService: profileService)
    }
} 