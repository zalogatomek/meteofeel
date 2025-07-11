import Foundation

extension String {
    public static func placeholder(length: Int) -> String {
        String(repeating: "X", count: length)
    }
}
