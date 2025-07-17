import SwiftUI

struct OnboardingPrimaryButton: View {

    // MARK: - Properties

    private let title: String
    private let action: () -> Void
    private let isLoading: Bool
    
    // MARK: - Lifecycle

    init(_ title: String, isLoading: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isLoading = isLoading
        self.action = action
    }

    // MARK: - View
    
    var body: some View {
        Button(action: isLoading ? {} : action) {
            Text(title)
                .padding(.horizontal)
                .shimmering(active: isLoading)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .clipShape(Capsule())
        .opacity(isLoading ? 0.5 : 1)
    }
}
