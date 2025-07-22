import SwiftUI

struct NavigationButton: View {
    
    // MARK: - Properties
    
    private let title: String
    private let action: () -> Void
    
    // MARK: - Lifecycle
    
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    // MARK: - View
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
        }
        .buttonStyle(.plain)
        .cardStyle()
    }
}

#Preview {
    VStack(spacing: 16) {
        NavigationButton(title: "Set your location") {
            // Preview action
        }
        
        NavigationButton(title: "5 health issues selected") {
            // Preview action
        }
    }
    .padding()
} 
