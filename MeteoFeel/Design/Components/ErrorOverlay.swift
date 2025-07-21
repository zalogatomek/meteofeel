import SwiftUI

struct ErrorOverlay: View {
    
    // MARK: - Properties
    
    private let message: String
    private let dismissButtonTitle: String
    private let onDismiss: () -> Void
    
    // MARK: - Lifecycle
    
    init(
        message: String,
        dismissButtonTitle: String = "Dismiss",
        onDismiss: @escaping () -> Void
    ) {
        self.message = message
        self.dismissButtonTitle = dismissButtonTitle
        self.onDismiss = onDismiss
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                
                VStack(spacing: 12) {
                    Text("Error")
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    
                    Text(message)
                        .font(.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                
                Button(dismissButtonTitle) {
                    onDismiss()
                }
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(8)
            }
            .padding(24)
            .background(Color.black.opacity(0.7))
            .cornerRadius(16)
            .padding(.horizontal, 40)
        }
    }
} 