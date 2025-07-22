import SwiftUI

struct TextSeparator: View {
    
    // MARK: - Properties
    
    private let text: String
    
    // MARK: - Lifecycle
    
    init(_ text: String) {
        self.text = text
    }
    
    // MARK: - View
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.secondary)
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        TextSeparator("or")
        TextSeparator("and")
        TextSeparator("alternatively")
    }
    .padding()
} 