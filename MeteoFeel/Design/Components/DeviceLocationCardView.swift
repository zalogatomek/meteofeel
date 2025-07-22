import SwiftUI

struct DeviceLocationCardView: View {
    
    // MARK: - Properties
    
    private let isLoading: Bool
    private let onGetDeviceLocation: () -> Void
    
    // MARK: - Lifecycle
    
    init(isLoading: Bool, onGetDeviceLocation: @escaping () -> Void) {
        self.isLoading = isLoading
        self.onGetDeviceLocation = onGetDeviceLocation
    }
    
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
                onGetDeviceLocation()
            }
            .buttonStyle(.plain)
            .foregroundColor(.accentColor)
            .controlSize(.large)
            .disabled(isLoading)
        }
        .cardStyle()
    }
}

#Preview {
    VStack(spacing: 16) {
        DeviceLocationCardView(isLoading: false) {
            print("Get location tapped")
        }
        
        DeviceLocationCardView(isLoading: true) {
            print("Get location tapped")
        }
    }
    .padding()
} 