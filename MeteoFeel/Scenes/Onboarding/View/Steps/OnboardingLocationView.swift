import SwiftUI
import MeteoFeelModel

struct OnboardingLocationView: View {
    
    // MARK: - Properties
    
    @Bindable private var form: UserProfileForm
    private let onNextStep: () -> Void
    private let onPreviousStep: () -> Void
    @State private var isShowingLocationSearch: Bool = false
    @State private var deviceLocationViewModel: DeviceLocationViewModel

    // MARK: - Lifecycle

    init(
        form: UserProfileForm, 
        onNextStep: @escaping () -> Void,
        onPreviousStep: @escaping () -> Void
    ) {
        self.form = form
        self.onNextStep = onNextStep
        self.onPreviousStep = onPreviousStep
        self._deviceLocationViewModel = State(initialValue: DeviceLocationViewModel(
            deviceLocationService: DeviceLocationServiceFactory.create(),
            onLocationSelected: { location in
                form.location = location
            }
        ))
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 40) {
            OnboardingTitleText("Where are you?")
            
            Text("Choose how you'd like to set your location. This will be used to fetch weather data for your area.")
                .font(.body)
                .multilineTextAlignment(.center)
            
            ScrollView {
                VStack(spacing: 20) {
                    LocationSearchCardView {
                        isShowingLocationSearch = true
                    }
                    
                    TextSeparator("or")
                    
                    DeviceLocationCardView(
                        isLoading: deviceLocationViewModel.isLoading
                    ) {
                        Task {
                            await deviceLocationViewModel.getDeviceLocation()
                        }
                    }
                    
                    if let selectedLocation = form.location {
                        SelectedLocationCardView(location: selectedLocation)
                    }
                }
            }
            .scrollClipDisabledForShadow()
            
            HStack {
                OnboardingSecondaryButton("Back") {
                    onPreviousStep()
                }
                
                Spacer()
                
                OnboardingPrimaryButton("Continue") {
                    onNextStep()
                }
                .disabled(!form.isLocationValid)
            }
        }
        .fullScreenCover(isPresented: $isShowingLocationSearch) {
            LocationSearchOverlay(
                onLocationSelected: { location in
                    form.location = location
                    isShowingLocationSearch = false
                }
            )
        }
        .overlay {
            if let errorMessage = deviceLocationViewModel.errorMessage {
                ErrorOverlay(message: errorMessage) {
                    deviceLocationViewModel.clearError()
                }
            }
        }
    }
}

// MARK: - SelectedLocationCardView

fileprivate struct SelectedLocationCardView: View {
    
    // MARK: - Properties
    
    let location: Location
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text("Selected Location")
                    .font(.headline)
                Spacer()
            }
            
            HStack {
                Text(location.name)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                Spacer()
            }
        }
        .cardStyle()
    }
}
