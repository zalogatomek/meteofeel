import SwiftUI
import MeteoFeelModel

struct OnboardingLocationView: View {
    
    // MARK: - Properties
    
    @Bindable private var form: UserProfileForm
    private let onNextStep: () -> Void
    private let onPreviousStep: () -> Void

    // MARK: - Lifecycle

    init(
        form: UserProfileForm, 
        onNextStep: @escaping () -> Void,
        onPreviousStep: @escaping () -> Void
    ) {
        self.form = form
        self.onNextStep = onNextStep
        self.onPreviousStep = onPreviousStep
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 40) {
            OnboardingTitleText("Where are you?")
            
            Text("We use your location to fetch accurate weather data for your area. Your location is only used to provide you with the best experience.")
                .font(.body)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            HStack {
                OnboardingSecondaryButton("Back") {
                    onPreviousStep()
                }
                
                Spacer()
                
                OnboardingPrimaryButton("Continue") {
                    onNextStep()
                }
                .disabled(!form.isLocationValid)
            }
        }
    }
}