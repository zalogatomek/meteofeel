import SwiftUI

fileprivate struct OnAppearFirstTimeModifier: ViewModifier {
    
    // MARK: - Properties

    private let action: () -> ()
    @State private var hasAppeared = false
    
    // MARK: - Lifecycle
    
    init(_ action: @escaping () -> ()) {
        self.action = action
    }
    
    // MARK: - ViewModifier
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                guard !hasAppeared else { return }
                hasAppeared = true
                action()
            }
    }
}

extension View {
    func onAppearFirstTime(_ action: @escaping () -> () ) -> some View {
        return modifier(OnAppearFirstTimeModifier(action))
    }
}
