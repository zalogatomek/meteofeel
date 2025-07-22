import SwiftUI

struct CardTextField: View {
    
    // MARK: - Properties
    
    private let placeholder: String
    @Binding private var text: String
    
    // MARK: - Lifecycle
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    // MARK: - View
    
    var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(.plain)
            .cardStyle()
    }
}

#Preview {
    @Previewable @State var name = ""
    @Previewable @State var email = ""
    @Previewable @FocusState var isFocused: Bool
    
    return VStack(spacing: 16) {
        CardTextField("Enter your name", text: $name)
            .focused($isFocused)
        
        CardTextField("Enter your email", text: $email)
        
        Button("Focus Name Field") {
            isFocused = true
        }
    }
    .padding()
} 