import Foundation

public protocol LocationServiceProtocol: Sendable {
    var suggestions: AsyncStream<[LocationSuggestion]> { get }
    func updateSearchQuery(_ query: String)
    func location(for suggestion: LocationSuggestion) async -> Location?
}
