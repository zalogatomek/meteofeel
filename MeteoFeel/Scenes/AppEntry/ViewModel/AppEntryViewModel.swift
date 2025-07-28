import Foundation
import MeteoFeelModel

@MainActor @Observable
final class AppEntryViewModel {
    
    // MARK: - Properties
    
    private let profileService: any ProfileServiceProtocol

    // MARK: - Lifecycle
    
    init(profileService: any ProfileServiceProtocol) {
        self.profileService = profileService
    }

    // MARK: - Output
    
    private(set) var isLoading: Bool = true
    private(set) var shouldShowOnboarding: Bool = false

    // MARK: - Input

    func onAppear() {
        Task {
            await determineInitialFlow()
        }
    }

    func onOnboardingFinished() {
        shouldShowOnboarding = false
    }

    // MARK: - Flow Logic
    
    private func determineInitialFlow() async {
        isLoading = true
        let profile = await profileService.loadProfile()
        shouldShowOnboarding = (profile == nil)
        isLoading = false
    }
} 
