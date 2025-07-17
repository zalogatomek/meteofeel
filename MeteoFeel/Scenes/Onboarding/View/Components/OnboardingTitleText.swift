import SwiftUI

struct OnboardingTitleText: View {

    // MARK: - Properties

    private let text: String

    // MARK: - Lifecycle

    init(_ text: String) {
        self.text = text
    }

    // MARK: - View
    
    var body: some View {
        Text(text)
            .font(.largeTitle.bold())
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}