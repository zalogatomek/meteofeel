import SwiftUI
import MeteoFeelModel

struct SettingsLocationView: View {
    
    // MARK: - Properties
    
    @State private var viewModel: DeviceLocationViewModel
    @State private var onLocationSelected: (Location) -> Void
    @State private var isShowingLocationSearch: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Lifecycle
    
    init(onLocationSelected: @escaping (Location) -> Void) {
        let deviceLocationService = DeviceLocationServiceFactory.create()
        self._viewModel = State(initialValue: DeviceLocationViewModel(
            deviceLocationService: deviceLocationService,
            onLocationSelected: onLocationSelected
        ))
        self.onLocationSelected = onLocationSelected
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 16) {
                        Text("Choose how you'd like to set your location. This will be used to fetch weather data for your area.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(spacing: 20) {
                        LocationSearchCardView {
                            isShowingLocationSearch = true
                        }
                        
                        TextSeparator("or")
                        
                        DeviceLocationCardView(
                            isLoading: viewModel.isLoading
                        ) {
                            Task {
                                await viewModel.getDeviceLocation()
                                dismiss()
                            }
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
        }
        .navigationTitle("Set Location")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $isShowingLocationSearch) {
            LocationSearchOverlay(
                onLocationSelected: { location in
                    isShowingLocationSearch = false
                    onLocationSelected(location)
                    dismiss()
                }
            )
        }
        .overlay {
            if let errorMessage = viewModel.errorMessage {
                ErrorOverlay(message: errorMessage) {
                    viewModel.clearError()
                }
            }
        }
    }
}
