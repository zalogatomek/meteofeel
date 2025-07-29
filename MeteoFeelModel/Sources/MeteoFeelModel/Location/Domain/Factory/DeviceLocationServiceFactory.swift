import Foundation

public final class DeviceLocationServiceFactory {

    // MARK: - Create

    public static func create() -> any DeviceLocationServiceProtocol {
        return DeviceLocationService()
    }
} 
