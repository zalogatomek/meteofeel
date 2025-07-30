import Foundation
import MeteoFeelModel
import MeteoFeelUtilities

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
    
    // MARK: - Forecast Header
    
    static func createForecastHeader(_ timePeriod: TimePeriod) -> String {
        let timeText = create(timePeriod)
        
        if timePeriod.date.isToday {
            return "Today's \(timeText) Forecast"
        } else if timePeriod.date.isTomorrow {
            return "\(timeText) Forecast"
        } else if timePeriod.date.isYesterday {
            return "\(timeText) Forecast"
        } else {
            return "\(timeText) Forecast"
        }
    }
}
