import SwiftUI

struct BackgroundView: View {
    
    // MARK: - View
    
    var body: some View {
        LinearGradient(
            colors: [.backgroundPrimary, .backgroundSecondary],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
