import Foundation

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

    // MARK: - Mutation

    public func bySettingName(_ name: String?) -> UserProfile {
        UserProfile(
            id: id,
            name: name,
            location: location,
            healthIssues: healthIssues
        )
    }

    public func bySettingLocation(_ location: Location) -> UserProfile {
        UserProfile(
            id: id,
            name: name,
            location: location,
            healthIssues: healthIssues
        )
    }

    public func bySettingHealthIssues(_ healthIssues: Set<HealthIssue>) -> UserProfile {
        UserProfile(
            id: id,
            name: name,
            location: location,
            healthIssues: healthIssues
        )
    }
} 