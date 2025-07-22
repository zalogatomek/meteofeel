import Foundation

public final class DeviceLocationServiceFactory {

    // MARK: - Create

    public static func create() -> DeviceLocationServiceProtocol {
        return DeviceLocationService()
    }
} 