import SwiftUI

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.quaternary, lineWidth: 0.5)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
            )
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
} 