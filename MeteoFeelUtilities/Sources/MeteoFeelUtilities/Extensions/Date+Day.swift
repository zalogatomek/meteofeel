public import Foundation

public extension Date {
    var now: Date { Date() }
    var isToday: Bool { Calendar.current.isDateInToday(self) }
    var isYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isTomorrow: Bool { Calendar.current.isDateInTomorrow(self) }
    var isInFuture: Bool { self > now }
} 
