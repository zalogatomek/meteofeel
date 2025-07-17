import SwiftUI

extension AnyTransition {

    // MARK: - Fade & Float

    static var fadeAndFloat: AnyTransition {
        .modifier(
            active: FadeAndFloatTransition(opacity: 0, offset: 100, scale: 0.92),
            identity: FadeAndFloatTransition(opacity: 1, offset: 0, scale: 1.0)
        )
    }
}

fileprivate struct FadeAndFloatTransition: ViewModifier {

    // MARK: - Properties

    let opacity: Double
    let offset: CGFloat
    let scale: CGFloat

    // MARK: - ViewModifier
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .offset(y: offset)
            .scaleEffect(scale)
    }
}