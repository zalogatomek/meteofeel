import SwiftUI
import MeteoFeelModel

struct OnboardingLocationView: View {
    
    // MARK: - Properties
    
    @Bindable private var form: UserProfileForm
    private let onNextStep: () -> Void
    private let onPreviousStep: () -> Void
    @State private var isShowingLocationSearch: Bool = false

    // MARK: - Lifecycle

    init(
        form: UserProfileForm, 
        onNextStep: @escaping () -> Void,
        onPreviousStep: @escaping () -> Void
    ) {
        self.form = form
        self.onNextStep = onNextStep
        self.onPreviousStep = onPreviousStep
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 40) {
            OnboardingTitleText("Where are you?")
            
            Text("Choose how you'd like to set your location. This will be used to fetch weather data for your area.")
                .font(.body)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 20) {
                LocationSearchCardView(
                    selectedLocation: form.location,
                    onTap: {
                        isShowingLocationSearch = true
                    }
                )
                
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.secondary)
                    Text("or")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.secondary)
                }
                
                CurrentLocationCardView(
                    onGetCurrentLocation: {
                        getCurrentLocation()
                    }
                )
            }
            
            Spacer()
            
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
    }
    
    // MARK: - Actions
    
    private func getCurrentLocation() {
        // TODO: Implement location services
        // For now, just simulate a delay
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
            await MainActor.run {
                // TODO: Set location from current location
            }
        }
    }
}

// MARK: - LocationSearchCardView

fileprivate struct LocationSearchCardView: View {
    
    // MARK: - Properties
    
    let selectedLocation: Location?
    let onTap: () -> Void
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.accentColor)
                Text("Search by city name")
                    .font(.headline)
                Spacer()
            }
            
            Button {
                onTap()
            } label: {
                HStack {
                    Text(selectedLocation?.name ?? "Enter city name")
                        .foregroundColor(selectedLocation != nil ? .primary : .secondary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            .buttonStyle(.plain)
        }
        .cardStyle()
    }
}

// MARK: - CurrentLocationCardView

fileprivate struct CurrentLocationCardView: View {
    
    // MARK: - Properties
    
    let onGetCurrentLocation: () -> Void
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.accentColor)
                Text("Use current location")
                    .font(.headline)
                Spacer()
            }
            
            Text("We'll get your location once. You can change it later in the app settings.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Button("Get Current Location") {
                onGetCurrentLocation()
            }
            .buttonStyle(.plain)
            .foregroundColor(.accentColor)
            .controlSize(.large)
        }
        .cardStyle()
    }
}
