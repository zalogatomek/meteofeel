import Foundation
import Testing
@testable import MeteoFeelUtilities

struct DateStartOfDayTests {

    // MARK: - Tests for startOfDay() method
    
    @Test(arguments: [
        Date(),
        Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!,
        Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
    ])
    func startOfDay(_ date: Date) throws {
        let startOfDay = date.startOfDay()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: startOfDay)
        let expectedComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: startOfDay)
        
        #expect(components.year == expectedComponents.year)
        #expect(components.month == expectedComponents.month)
        #expect(components.day == expectedComponents.day)
        #expect(timeComponents.hour == 0)
        #expect(timeComponents.minute == 0)
        #expect(timeComponents.second == 0)
    }
} 
