import Foundation
import CoreLocation
import MapKit

actor DeviceLocationService: NSObject, DeviceLocationServiceProtocol, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    private var permissionContinuation: CheckedContinuation<Void, any Error>?
    private var locationContinuation: CheckedContinuation<CLLocation, any Error>?
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
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
        do {
            let geocoder = CLGeocoder()
            guard let placemark = try await geocoder.reverseGeocodeLocation(clLocation).first,
                  let name = formatLocationName(from: placemark)
            else { throw DeviceLocationError.geocodingFailed }
            
            return Location(
                name: name,
                coordinates: Coordinates(
                    latitude: clLocation.coordinate.latitude,
                    longitude: clLocation.coordinate.longitude
                )
            )
        } catch {
            throw DeviceLocationError.geocodingFailed
        }
    }
    
    private func formatLocationName(from placemark: CLPlacemark) -> String? {
        if let locality = placemark.locality { locality }
        else if let country = placemark.country { country }
        else { nil }
    }

    // MARK: - CLLocationManagerDelegate
    
    nonisolated func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        Task {
            await handleLocationManagerDidChangeAuthorization(status)
        }
    }
    
    private func handleLocationManagerDidChangeAuthorization(_ status: CLAuthorizationStatus) async {
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
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task {
            await handleLocationManagerDidUpdateLocations(locations)
        }
    }

    private func handleLocationManagerDidUpdateLocations(_ locations: [CLLocation]) async {
        guard let location = locations.last,
              let continuation = locationContinuation
        else { return }
        
        locationContinuation = nil

        continuation.resume(returning: location)
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        Task {
            await handleLocationManagerDidFailWithError(error)
        }
    }

    private func handleLocationManagerDidFailWithError(_ error: any Error) async {
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
