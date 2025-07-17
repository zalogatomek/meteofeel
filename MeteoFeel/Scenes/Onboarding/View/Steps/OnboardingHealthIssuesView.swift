import SwiftUI
import MeteoFeelModel

struct OnboardingHealthIssuesView: View {
    
    // MARK: - Properties
    
    @Bindable private var form: UserProfileForm
    private let isLoading: Bool
    private let onFinish: () -> Void
    private let onPreviousStep: () -> Void
    
    // MARK: - Lifecycle

    init(
        form: UserProfileForm,
        isLoading: Bool,
        onFinish: @escaping () -> Void, 
        onPreviousStep: @escaping () -> Void
    ) {
        self.form = form
        self.onFinish = onFinish
        self.onPreviousStep = onPreviousStep
        self.isLoading = isLoading
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 40) {
            OnboardingTitleText("Select health issues you want to track")
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(HealthIssue.allCases.sorted(), id: \.self) { issue in
                        Toggle(
                            issue.rawValue.capitalized,
                            isOn: Binding(
                                get: { form.healthIssues.contains(issue) },
                                set: { isSelected in form.setHealthIssue(issue, selected: isSelected) }
                            )
                        )
                        .toggleStyle(.switch)
                        .padding(.trailing, 2)
                    }
                }
            }
            
            Spacer()
            
            HStack {
                OnboardingSecondaryButton("Back") {
                    onPreviousStep()
                }
                
                Spacer()
                
                OnboardingPrimaryButton("Finish", isLoading: isLoading) {
                    onFinish()
                }
                .disabled(!form.isValid)
            }
        }
    }
}
