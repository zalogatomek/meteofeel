import Foundation
import MeteoFeelModel

@MainActor @Observable
final class LocationSearchViewModel {
    
    // MARK: - Properties
    
    private let locationService: any LocationServiceProtocol
    private let onLocationSelected: (Location) -> Void
    private var suggestionsTask: Task<Void, Never>?
    
    // MARK: - Lifecycle
    
    init(
        locationService: any LocationServiceProtocol,
        onLocationSelected: @escaping (Location) -> Void
    ) {
        self.locationService = locationService
        self.onLocationSelected = onLocationSelected
    }

    // MARK: - Output

    var suggestions: [LocationSuggestion] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    // MARK: - Input
    
    func setIsVisible(_ isVisible: Bool) {
        if isVisible {
            startObservingSuggestions()
        } else {
            suggestionsTask?.cancel()
        }
    }

    var searchQuery: String = "" {
        didSet {
            Task {
                await locationService.updateSearchQuery(searchQuery)
            }
        }
    }
    
    func selectSuggestion(_ suggestion: LocationSuggestion) async {
        isLoading = true
        errorMessage = nil
        
        if let location = await locationService.location(for: suggestion) {
            onLocationSelected(location)
        } else {
            errorMessage = "Unable to get location details for \(suggestion.title)"
        }
        
        isLoading = false
    }
    
    func clearSearch() {
        searchQuery = ""
        suggestions = []
        errorMessage = nil
        isLoading = false
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Helpers
    
    private func startObservingSuggestions() {
        suggestionsTask = Task { @MainActor in
            for await suggestions in await locationService.suggestions {
                self.suggestions = suggestions
            }
        }
    }
    
    private func stopObservingSuggestions() {
        suggestionsTask?.cancel()
    }
}
