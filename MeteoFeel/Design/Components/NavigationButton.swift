import SwiftUI

struct NavigationButton<Destination: View>: View {
    
    // MARK: - Properties
    
    private let title: String
    private let destination: Destination
    
    // MARK: - Lifecycle
    
    init(title: String, @ViewBuilder destination: () -> Destination) {
        self.title = title
        self.destination = destination()
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .cardStyle()
    }
}

#Preview {
    NavigationStack {
        VStack(spacing: 16) {
            NavigationButton(title: "Set your location") {
                Text("Location Settings")
            }
            
            NavigationButton(title: "5 health issues selected") {
                Text("Health Issues Settings")
            }
        }
        .padding()
    }
} 
