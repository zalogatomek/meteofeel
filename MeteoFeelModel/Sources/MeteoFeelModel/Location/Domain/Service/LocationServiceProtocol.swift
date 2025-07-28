import Foundation

public protocol LocationServiceProtocol: Sendable {
    @MainActor var suggestions: AsyncStream<[LocationSuggestion]> { get async }
    @MainActor func updateSearchQuery(_ query: String) async
    @MainActor func location(for suggestion: LocationSuggestion) async -> Location?
}
