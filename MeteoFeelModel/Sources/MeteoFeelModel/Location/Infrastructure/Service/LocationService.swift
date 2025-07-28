import Foundation
@preconcurrency import MapKit

final class LocationService: NSObject, LocationServiceProtocol, MKLocalSearchCompleterDelegate {
    
    // MARK: - Properties
    
    private let searchCompleter = MKLocalSearchCompleter()
    private let suggestionsSubject = AsyncStream<[LocationSuggestion]>.makeStream()
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
    
    // MARK: - LocationServiceProtocol
    
    @MainActor var suggestions: AsyncStream<[LocationSuggestion]> {
        suggestionsSubject.stream
    }
    
    @MainActor func updateSearchQuery(_ query: String) async {
        searchCompleter.queryFragment = query
    }
    
    @MainActor func location(for suggestion: LocationSuggestion) async -> Location? {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = suggestion.title
        let search = MKLocalSearch(request: searchRequest)
        
        do {
            let response = try await search.start()
            guard let mapItem = response.mapItems.first else { return nil }
            
            return Location(
                name: suggestion.title,
                coordinates: Coordinates(
                    latitude: mapItem.placemark.coordinate.latitude,
                    longitude: mapItem.placemark.coordinate.longitude
                )
            )
        } catch {
            return nil
        }
    }
    
    // MARK: - MKLocalSearchCompleterDelegate
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let suggestions = completer.results
            .map { completion -> LocationSuggestion in
                LocationSuggestion(
                    title: completion.title,
                    subtitle: completion.subtitle
                )
            }
            .unique(by: \.title)
            
        let continuation = suggestionsSubject.continuation
        Task { @MainActor in
            continuation.yield(suggestions)
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        let continuation = suggestionsSubject.continuation
        Task { @MainActor in
            continuation.yield([])
        }
    }
}
