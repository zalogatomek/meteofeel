import SwiftUI

struct OnboardingWelcomeView: View {
    
    // MARK: - Properties
    
    private let onNextStep: () -> Void

    // MARK: - Lifecycle

    init(onNextStep: @escaping () -> Void) {
        self.onNextStep = onNextStep
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 40) {
            OnboardingTitleText("Welcome to MeteoFeel!")
            
            Text("Your personal weather & well-being companion. Discover how weather impacts your health and comfort.")
                .font(.body)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
            HStack {
                Spacer()

                OnboardingPrimaryButton("Let's start") {
                    onNextStep()
                }
            }
        }
    }
}
