import Foundation
import MeteoFeelModel

@Observable @MainActor
final class OnboardingViewModel {

    enum Step: Int, CaseIterable {
        case welcome
        case name
        case location
        case healthIssues
    }
    
    // MARK: - Properties

    private let profileService: ProfileServiceProtocol
    let form = UserProfileForm()
    var onFinish: (() -> Void)?
    
    // MARK: - Output

    private(set) var currentStep: Step = .welcome
    private(set) var isSaving: Bool = false
    
    // MARK: - Lifecycle

    init(profileService: ProfileServiceProtocol) {
        self.profileService = profileService
    }
    
    // MARK: - Input
    
    func nextStep() {
        if let next = Step(rawValue: currentStep.rawValue + 1) {
            currentStep = next
        }
    }
    
    func previousStep() {
        if let prev = Step(rawValue: currentStep.rawValue - 1) {
            currentStep = prev
        }
    }
    
    func finishOnboarding() {
        guard let profile = form.createUserProfile() else { return }
        
        Task {
            isSaving = true
            try? await profileService.saveProfile(profile)
            isSaving = false
            onFinish?()
        }
    }
}
