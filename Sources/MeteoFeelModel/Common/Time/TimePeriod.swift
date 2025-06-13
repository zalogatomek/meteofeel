import Foundation

public struct TimePeriod: Codable, Equatable {
    public let date: Date
    public let timeOfDay: TimeOfDay
    
    public init(date: Date, timeOfDay: TimeOfDay) {
        self.date = date
        self.timeOfDay = timeOfDay
    }
} 