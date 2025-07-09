import SwiftUI

public extension View {
    @ViewBuilder func redacted(_ condition: Bool) -> some View {
        redacted(reason: condition ? .placeholder : RedactionReasons(rawValue: 0))
    }
}
