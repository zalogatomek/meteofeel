import SwiftUI
import MeteoFeelModel
import MeteoFeelUtilities

struct OnboardingNameView: View {
    
    // MARK: - Properties
    
    @Bindable private var form: UserProfileForm
    private let onNextStep: () -> Void
    private let onPreviousStep: () -> Void
    @FocusState private var isFocused: Bool

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
            OnboardingTitleText("What's your name?")
            
            CardTextField("Enter your name (optional)", text: Binding(
                get: { form.name ?? "" },
                set: { form.name = $0.nilIfEmpty }
            ))
            .focused($isFocused)
            
            Spacer()
            
            HStack {
                OnboardingSecondaryButton("Back") {
                    onPreviousStep()
                }
                
                Spacer()
                
                OnboardingPrimaryButton(form.name?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? "Continue" : "Skip") {
                    onNextStep()
                }
                .disabled(!form.isNameValid)
            }
        }
        .onAppear { isFocused = true }
    }
}
