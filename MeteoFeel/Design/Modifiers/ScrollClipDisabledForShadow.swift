import SwiftUI

struct ScrollClipDisabledForShadowModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .scrollClipDisabled()
            .padding(10)
            .clipShape(Rectangle())
            .padding(-10)
    }
}

extension View {
    func scrollClipDisabledForShadow() -> some View {
        modifier(ScrollClipDisabledForShadowModifier())
    }
}

