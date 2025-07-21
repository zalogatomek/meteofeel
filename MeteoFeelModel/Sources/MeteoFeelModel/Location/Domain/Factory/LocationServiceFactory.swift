import Foundation

public final class LocationServiceFactory {

    // MARK: - Create

    public static func create() -> LocationServiceProtocol {
        return LocationService()
    }
} 