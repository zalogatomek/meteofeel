import MeteoFeelModel
import SwiftUI

struct OnboardingView: View {

    // MARK: - Properties

    @State private var viewModel: OnboardingViewModel

    // MARK: - Lifecycle

    init(
        profileService: ProfileServiceProtocol = ProfileServiceFactory.create(),
        onFinish: @escaping () -> Void
    ) {
        self._viewModel = State(initialValue: OnboardingViewModel(profileService: profileService))
        self.viewModel.onFinish = onFinish
    }

    // MARK: - View

    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            ZStack {
                switch viewModel.currentStep {
                case .welcome:
                    OnboardingWelcomeView(onNextStep: viewModel.nextStep)
                        .transition(.fadeAndFloat)
                    
                case .name:
                    OnboardingNameView(
                        form: viewModel.form,
                        onNextStep: viewModel.nextStep,
                        onPreviousStep: viewModel.previousStep
                    )
                    .transition(.fadeAndFloat)
                    
                case .location:
                    OnboardingLocationView(
                        form: viewModel.form,
                        onNextStep: viewModel.nextStep,
                        onPreviousStep: viewModel.previousStep
                    )
                    .transition(.fadeAndFloat)
                    
                case .healthIssues:
                    OnboardingHealthIssuesView(
                        form: viewModel.form,
                        isLoading: viewModel.isSaving,
                        onFinish: viewModel.finishOnboarding,
                        onPreviousStep: viewModel.previousStep
                    )
                    .transition(.fadeAndFloat)
                }
            }
            .padding()
            .padding(.top)
            .animation(
                .interpolatingSpring(stiffness: 180, damping: 22, initialVelocity: 0.7),
                value: viewModel.currentStep
            )
        }
    }
}
