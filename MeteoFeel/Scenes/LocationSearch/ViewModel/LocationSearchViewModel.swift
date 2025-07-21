import Foundation
import MeteoFeelModel

@Observable final class LocationSearchViewModel {
    
    // MARK: - Properties
    
    private let locationService: LocationServiceProtocol
    private let onLocationSelected: (Location) -> Void
    private var suggestionsTask: Task<Void, Never>?
    
    // MARK: - Lifecycle
    
    init(
        locationService: LocationServiceProtocol,
        onLocationSelected: @escaping (Location) -> Void
    ) {
        self.locationService = locationService
        self.onLocationSelected = onLocationSelected
        setupSuggestionsStream()
    }
    
    deinit {
        suggestionsTask?.cancel()
    }

    private func setupSuggestionsStream() {
        suggestionsTask = Task { @MainActor in
            for await suggestions in locationService.suggestions {
                self.suggestions = suggestions
            }
        }
    }

    // MARK: - Output

    @MainActor var suggestions: [LocationSuggestion] = []
    @MainActor var isLoading: Bool = false
    @MainActor var errorMessage: String?
    
    // MARK: - Input

    @MainActor var searchQuery: String = "" {
        didSet {
            locationService.updateSearchQuery(searchQuery)
        }
    }
    
    @MainActor
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
    
    @MainActor
    func clearSearch() {
        searchQuery = ""
        suggestions = []
        errorMessage = nil
        isLoading = false
    }
    
    @MainActor
    func clearError() {
        errorMessage = nil
    }
} 