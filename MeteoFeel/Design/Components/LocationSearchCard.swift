import SwiftUI

struct LocationSearchCardView: View {
    
    // MARK: - Properties
    
    private let onTap: () -> Void
    
    // MARK: - Lifecycle
    
    init(onTap: @escaping () -> Void) {
        self.onTap = onTap
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.accentColor)
                
                Text("Search by city name")
                    .font(.headline)
                
                Spacer()
            }
            
            Button {
                onTap()
            } label: {
                HStack {
                    Text("Enter city name")
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            .buttonStyle(.plain)
        }
        .cardStyle()
    }
}

#Preview {
    LocationSearchCardView {
        print("Search tapped")
    }
    .padding()
} 