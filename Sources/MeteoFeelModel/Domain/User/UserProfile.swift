import Foundation

public struct UserProfile: Codable, Equatable {
    public let id: UUID
    public let name: String
    public let location: Location
    public let healthIssues: [HealthIssue]
    
    public init(
        id: UUID = UUID(),
        name: String,
        location: Location,
        healthIssues: [HealthIssue]
    ) {
        self.id = id
        self.name = name
        self.location = location
        self.healthIssues = healthIssues
    }
} 