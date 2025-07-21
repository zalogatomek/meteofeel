import Foundation

public extension Array where Element: CustomStringConvertible {
    func sortedByDescription() -> Self {
        sorted(by: { lhs, rhs in
            lhs.description.localizedCompare(rhs.description) == .orderedAscending
        })
    }
}
