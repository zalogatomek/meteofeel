import Foundation

public final class LocationServiceFactory {

    // MARK: - Create

    public static func create() -> any LocationServiceProtocol {
        return LocationService()
    }
} 
