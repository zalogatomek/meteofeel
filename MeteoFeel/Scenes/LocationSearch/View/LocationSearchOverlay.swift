import SwiftUI
import MeteoFeelModel

struct LocationSearchOverlay: View {
    
    // MARK: - Properties
    
    @State private var viewModel: LocationSearchViewModel
    @FocusState private var isSearchFieldFocused: Bool
    
    // MARK: - Lifecycle
    
    init(
        onLocationSelected: @escaping (Location) -> Void
    ) {
        self._viewModel = State(initialValue: LocationSearchViewModel(
            locationService: LocationServiceFactory.create(),
            onLocationSelected: onLocationSelected
        ))
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        SearchTextField(
                            "Search for a city or location",
                            text: $viewModel.searchQuery,
                            onClear: {
                                viewModel.clearSearch()
                            }
                        )
                        .focused($isSearchFieldFocused)
                        .disabled(viewModel.isLoading)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    
                    Divider()
                    
                    if viewModel.searchQuery.isEmpty {
                        EmptyScreenView(
                            imageName: "location.magnifyingglass",
                            title: "Search for your location",
                            subtitle: "Start typing to find cities, neighborhoods, or landmarks"
                        )
                    } else if viewModel.suggestions.isEmpty {
                        EmptyScreenView(
                            imageName: "location.slash",
                            title: "No locations found",
                            subtitle: "Try searching with a different term"
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(viewModel.suggestions, id: \.title) { suggestion in
                                    LocationSearchSuggestionRowView(suggestion: suggestion) {
                                        Task {
                                            await viewModel.selectSuggestion(suggestion)
                                        }
                                    }
                                    
                                    if suggestion.title != viewModel.suggestions.last?.title {
                                        Divider()
                                            .padding(.leading, 48)
                                    }
                                }
                            }
                        }
                        .disabled(viewModel.isLoading)
                    }
                }
                .blur(radius: viewModel.isLoading || viewModel.errorMessage != nil ? 2 : 0)
                .disabled(viewModel.isLoading || viewModel.errorMessage != nil)
                
                if viewModel.isLoading {
                    LoadingOverlay(message: "Getting location details...")
                }
                
                if let errorMessage = viewModel.errorMessage {
                    ErrorOverlay(message: errorMessage) {
                        viewModel.clearError()
                    }
                }
            }
            .navigationTitle("Choose Location")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            isSearchFieldFocused = true
        }
        .isVisible {
            viewModel.setIsVisible($0)
        }
    }
} 
