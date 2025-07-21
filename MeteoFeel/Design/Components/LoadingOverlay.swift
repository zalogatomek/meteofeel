import SwiftUI

struct LoadingOverlay: View {
    
    // MARK: - Properties
    
    private let message: String
    
    // MARK: - Lifecycle
    
    init(message: String = "Loading...") {
        self.message = message
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .fontWeight(.medium)
            }
            .padding(24)
            .background(Color.black.opacity(0.7))
            .cornerRadius(16)
        }
    }
} 