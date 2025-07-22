import Foundation
import CoreLocation
@preconcurrency import MapKit

final class DeviceLocationService: NSObject, DeviceLocationServiceProtocol, CLLocationManagerDelegate, @unchecked Sendable {
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var permissionContinuation: CheckedContinuation<Void, Error>?
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    // MARK: - DeviceLocationServiceProtocol
    
    func getDeviceLocation() async throws -> Location {
        try await checkLocationPermission()
        let clLocation = try await getCurrentCLLocation()
        return try await geocodeLocation(clLocation)
    }
    
    // MARK: - Helpers
    
    private func checkLocationPermission() async throws {
        let authorizationStatus = locationManager.authorizationStatus
        
        switch authorizationStatus {
        case .notDetermined:
            try await requestLocationPermission()
        case .denied, .restricted:
            throw DeviceLocationError.permissionDenied
        case .authorizedWhenInUse, .authorizedAlways:
            break
        @unknown default:
            throw DeviceLocationError.permissionDenied
        }
    }
    
    private func requestLocationPermission() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            permissionContinuation = continuation
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func getCurrentCLLocation() async throws -> CLLocation {
        return try await withCheckedThrowingContinuation { continuation in
            if let location = locationManager.location {
                continuation.resume(returning: location)
            } else {
                locationContinuation = continuation
                locationManager.requestLocation()
            }
        }
    }
    
    private func geocodeLocation(_ clLocation: CLLocation) async throws -> Location {
        return try await withCheckedThrowingContinuation { continuation in
            geocoder.reverseGeocodeLocation(clLocation) { placemarks, error in
                if let error {
                    continuation.resume(throwing: DeviceLocationError.geocodingFailed)
                    return
                }
                
                guard let placemark = placemarks?.first,
                      let name = self.formatLocationName(from: placemark)
                else {
                    continuation.resume(throwing: DeviceLocationError.geocodingFailed)
                    return
                }
                
                let location = Location(
                    name: name,
                    coordinates: Coordinates(
                        latitude: clLocation.coordinate.latitude,
                        longitude: clLocation.coordinate.longitude
                    )
                )
                
                continuation.resume(returning: location)
            }
        }
    }
    
    private func formatLocationName(from placemark: CLPlacemark) -> String? {
        if let locality = placemark.locality { locality }
        else if let country = placemark.country { country }
        else { nil }
    }

    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let continuation = permissionContinuation else { return }
        
        permissionContinuation = nil
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            continuation.resume()
        case .denied, .restricted:
            continuation.resume(throwing: DeviceLocationError.permissionDenied)
        case .notDetermined:
            // Still waiting for user decision
            permissionContinuation = continuation
        @unknown default:
            continuation.resume(throwing: DeviceLocationError.permissionDenied)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last,
              let continuation = locationContinuation
        else { return }
        
        locationContinuation = nil
        continuation.resume(returning: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let continuation = locationContinuation else { return }
        
        locationContinuation = nil

        switch (error as? CLError)?.code {
        case .denied:
            continuation.resume(throwing: DeviceLocationError.permissionDenied)
        default:
            continuation.resume(throwing: DeviceLocationError.locationUnavailable)
        }
    }
}
