import Foundation

public extension Array {
    func unique<Value: Hashable>(by keyPath: KeyPath<Element, Value>) -> Self {
        var addedDict = [Value: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0[keyPath: keyPath]) == nil
        }
    }
}

public extension Array where Element: Hashable {
    func unique() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
}

public extension Array where Element: CustomStringConvertible {
    func uniqueByDescription() -> Self {
        var filteredArray = Array()
        var addedElements = Set<String>()
        for element in self {
            if !addedElements.contains(element.description) {
                filteredArray.append(element)
                addedElements.insert(element.description)
            }
        }
        return filteredArray
    }
}
