public import Foundation
import MeteoFeelUtilities

public struct TimePeriod: Codable, Hashable, Comparable, Sendable {

    // MARK: - Properties
    
    public let date: Date
    public let timeOfDay: TimeOfDay
    
    // MARK: - Lifecycle

    public init(date: Date, timeOfDay: TimeOfDay) {
        self.date = date.startOfDay()
        self.timeOfDay = timeOfDay
    }
    
    public init?(date: Date, calendar: Calendar = .current) {
        self.date = date.startOfDay(calendar: calendar)
        switch calendar.component(.hour, from: date) {
        case 6..<12: self.timeOfDay = .morning
        case 12..<18: self.timeOfDay = .afternoon
        case 18..<24: self.timeOfDay = .evening
        default: return nil
        }
    }

    // MARK: - Helpers
    
    public func next(calendar: Calendar = .current) -> TimePeriod {
        switch timeOfDay {
        case .morning:
            return TimePeriod(date: date, timeOfDay: .afternoon)
        case .afternoon:
            return TimePeriod(date: date, timeOfDay: .evening)
        case .evening:
            let nextDay = calendar.date(byAdding: .day, value: 1, to: date) ?? date
            return TimePeriod(date: nextDay, timeOfDay: .morning)
        }
    }

    // MARK: - Comparable
    
    public static func < (lhs: TimePeriod, rhs: TimePeriod) -> Bool {
        if lhs.date == rhs.date {
            return lhs.timeOfDay < rhs.timeOfDay
        } else {
            return lhs.date < rhs.date
        }
    }
}

extension TimePeriod {
    
    // MARK: - Stubs
    
    public static func createStub(
        date: Date = Date(),
        timeOfDay: TimeOfDay = .morning
    ) -> TimePeriod {
        TimePeriod(date: date, timeOfDay: timeOfDay)
    }
} 
