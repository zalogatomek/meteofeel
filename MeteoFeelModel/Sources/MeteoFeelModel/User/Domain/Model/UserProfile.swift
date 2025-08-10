public import Foundation

public struct UserProfile: Codable, Equatable, Sendable {

    // MARK: - Properties

    public let id: UUID
    public let name: String?
    public let location: Location
    public let healthIssues: Set<HealthIssue>

    // MARK: - Lifecycle
    
    public init(
        id: UUID = UUID(),
        name: String?,
        location: Location,
        healthIssues: Set<HealthIssue>
    ) {
        self.id = id
        self.name = name
        self.location = location
        self.healthIssues = healthIssues
    }
}

extension UserProfile {
    
    // MARK: - Stubs
    
    public static func createStub(
        id: UUID = UUID(),
        name: String? = "Test User",
        location: Location = Location.createStub(),
        healthIssues: Set<HealthIssue> = [.headache, .fatigue]
    ) -> UserProfile {
        return UserProfile(
            id: id,
            name: name,
            location: location,
            healthIssues: healthIssues
        )
    }
}
