import Foundation

public extension Array {
    func unique<Value: Hashable>(by keyPath: KeyPath<Element, Value>) -> Self {
        var seen: Set<Value> = []
        return filter { seen.insert($0[keyPath: keyPath]).inserted }
    }
}

public extension Array where Element: Hashable {
    func unique() -> [Element] {
        var seen: Set<Element> = []
        return filter { seen.insert($0).inserted }
    }
}

public extension Array where Element: CustomStringConvertible {
    func uniqueByDescription() -> Self {
        var seen: Set<String> = []
        return filter { seen.insert($0.description).inserted }
    }
} 