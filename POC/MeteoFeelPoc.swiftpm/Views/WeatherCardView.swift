import SwiftUI

struct WeatherCardView<Content: View>: View {
    // MARK: - Properties
    
    let title: String?
    let content: Content
    
    // MARK: - Lifecycle
    
    init(title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let title = title {
                Text(title)
                    .font(.headline)
                    .padding()
            }
            content
        }
        .background(Color(.systemBackground).opacity(0.95))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
} 