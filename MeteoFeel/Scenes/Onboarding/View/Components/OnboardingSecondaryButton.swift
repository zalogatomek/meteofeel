import SwiftUI

struct OnboardingSecondaryButton: View {

    // MARK: - Properties

    private let title: String
    private let action: () -> Void

    // MARK: - Lifecycle

    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    // MARK: - View

    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal)
        }
        .buttonStyle(.plain)
        .controlSize(.large)
    }
}
