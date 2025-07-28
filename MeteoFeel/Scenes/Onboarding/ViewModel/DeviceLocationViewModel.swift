import Foundation
import MeteoFeelModel

@MainActor @Observable
final class DeviceLocationViewModel {
    
    // MARK: - Properties
    
    private let deviceLocationService: any DeviceLocationServiceProtocol
    private let onLocationSelected: (Location) -> Void
    
    // MARK: - Output
    
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?
    
    // MARK: - Lifecycle
    
    init(
        deviceLocationService: any DeviceLocationServiceProtocol,
        onLocationSelected: @escaping (Location) -> Void
    ) {
        self.deviceLocationService = deviceLocationService
        self.onLocationSelected = onLocationSelected
    }
    
    // MARK: - Input
    
    func getDeviceLocation() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let location = try await deviceLocationService.getDeviceLocation()
            onLocationSelected(location)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
} 
