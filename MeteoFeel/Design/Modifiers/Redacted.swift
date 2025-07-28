import SwiftUI

extension View {
    func redacted(_ condition: Bool) -> some View {
        self
            .redacted(reason: condition ? .placeholder : RedactionReasons(rawValue: 0))
            .shimmering(active: condition)
    }
}
