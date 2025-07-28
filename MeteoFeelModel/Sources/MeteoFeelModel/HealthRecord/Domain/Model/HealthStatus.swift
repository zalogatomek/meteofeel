public import Foundation

public struct HealthStatus: Equatable, Codable, Sendable {
    public let date: Date
    public let timeOfDay: [TimeOfDay]
    public let wellBeing: WellBeing
    public let issues: [HealthIssue]

    public init(
        date: Date,
        timeOfDay: [TimeOfDay],
        wellBeing: WellBeing,
        issues: [HealthIssue]
    ) {
        self.date = date
        self.timeOfDay = timeOfDay
        self.wellBeing = wellBeing
        self.issues = issues
    }
} 
