import Foundation
import MeteoFeelModel

@MainActor @Observable
final class SettingsViewModel {
    
    // MARK: - Properties
    
    private let profileService: any ProfileServiceProtocol
    
    // MARK: - Lifecycle
    
    init(profileService: any ProfileServiceProtocol) {
        self.profileService = profileService
    }
    
    // MARK: - Output
    
    private(set) var form: UserProfileForm?
    private(set) var isLoading: Bool = false
    private(set) var isSaving: Bool = false
    private(set) var errorMessage: String?
    
    // MARK: - Input
    
    func onAppear() {
        guard form == nil else { return }
        
        Task {
            await loadProfile()
        }
    }
    
    func saveProfile() async -> Bool {
        guard let form = form, let profile = form.createUserProfile() else { 
            errorMessage = "Unable to save profile"
            return false
        }
        
        isSaving = true
        errorMessage = nil
        
        do {
            try await profileService.saveProfile(profile)
            isSaving = false
        } catch {
            errorMessage = "Failed to save profile"
            isSaving = false
            return false
        }

        return true
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Private Methods
    
    private func loadProfile() async {
        isLoading = true
        errorMessage = nil
        
        let profile = await profileService.loadProfile()
        form = UserProfileForm(userProfile: profile)
        
        isLoading = false
    }
}
