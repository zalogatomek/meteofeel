import Foundation
@testable public import MeteoFeelModel

public final class MockProfileService: ProfileServiceProtocol, @unchecked Sendable {
    public var profile: UserProfile?
    
    public init() {}
    
    public func loadProfile() async -> UserProfile? {
        return profile
    }
    
    public func saveProfile(_ profile: UserProfile) async throws {
        self.profile = profile
    }
}
