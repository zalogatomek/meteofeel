import SwiftUI

struct EmptyScreenView: View {
    
    // MARK: - Properties
    
    private let imageName: String
    private let title: String
    private let subtitle: String
    
    // MARK: - Lifecycle
    
    init(
        imageName: String,
        title: String,
        subtitle: String
    ) {
        self.imageName = imageName
        self.title = title
        self.subtitle = subtitle
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding()
    }
} 