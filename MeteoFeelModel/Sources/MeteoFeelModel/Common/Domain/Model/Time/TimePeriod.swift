import Foundation

public struct TimePeriod: Codable, Hashable, Comparable, Sendable {
    public let date: Date
    public let timeOfDay: TimeOfDay
    
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
    
    public static func < (lhs: TimePeriod, rhs: TimePeriod) -> Bool {
        if lhs.date == rhs.date {
            return lhs.timeOfDay < rhs.timeOfDay
        } else {
            return lhs.date < rhs.date
        }
    }
} 