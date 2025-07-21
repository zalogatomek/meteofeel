import SwiftUI

struct SearchTextField: View {
    
    // MARK: - Properties
    
    private let title: String
    @Binding private var text: String
    private let onClear: (() -> Void)?
    
    // MARK: - Lifecycle
    
    init(
        _ title: String,
        text: Binding<String>,
        onClear: (() -> Void)? = nil
    ) {
        self.title = title
        self._text = text
        self.onClear = onClear
    }
    
    // MARK: - View
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField(title, text: $text)
                .textFieldStyle(.plain)
            
            if !text.isEmpty {
                Button {
                    text = ""
                    onClear?()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
} 