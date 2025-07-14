import Foundation
import MeteoFeelModel

struct TimePeriodStringFactory {
    
    // MARK: - Create
    
    static func create(_ timePeriod: TimePeriod) -> String {
        if timePeriod.date.isToday {
            return timePeriod.timeOfDay.displayName.capitalized
        } else if timePeriod.date.isTomorrow {
            return "Tomorrow \(timePeriod.timeOfDay.displayName.lowercased())"
        } else if timePeriod.date.isYesterday {
            return "Yesterday \(timePeriod.timeOfDay.displayName.lowercased())"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            let dateText = formatter.string(from: timePeriod.date)
            return "\(dateText), \(timePeriod.timeOfDay.displayName.lowercased())"
        }
    }
}
