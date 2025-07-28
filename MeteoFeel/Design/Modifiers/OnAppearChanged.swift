import SwiftUI

extension View {
    func onAppearChanged(perform action: @escaping (Bool) -> Void) -> some View {
        self
            .onAppear {
                action(true)
            }
            .onDisappear {
                action(false)
            }
    }
    
    func isVisible(_ handler: @escaping (Bool) -> Void) -> some View {
        onAppearChanged(perform: handler)
    }
}
