import SwiftUI

extension View {
    @ViewBuilder func redacted(_ condition: Bool) -> some View {
        self
            .redacted(reason: condition ? .placeholder : RedactionReasons(rawValue: 0))
            .shimmering(active: condition)
    }
}
