import Foundation
import Testing
@testable import MeteoFeelModel

struct TimePeriodTests {

    // MARK: - Tests
    
    @Test func initWithDateAndTimeOfDay() throws {
        let date = Date()
        let timeOfDay = TimeOfDay.morning
        
        let timePeriod = TimePeriod(date: date, timeOfDay: timeOfDay)
        
        #expect(timePeriod.date == date.startOfDay())
        #expect(timePeriod.timeOfDay == timeOfDay)
    }
    
    @Test(arguments: zip([8, 14, 20], [TimeOfDay.morning, .afternoon, .evening]))
    func initWithDateAndCalendar(_ hour: Int, expectedTimeOfDay: TimeOfDay) throws {
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: 2024, month: 1, day: 15, hour: hour))!
        
        let timePeriod = try #require(TimePeriod(date: date, calendar: calendar))
        
        #expect(timePeriod.timeOfDay == expectedTimeOfDay)
        #expect(timePeriod.date == date.startOfDay(calendar: calendar))
    }
    
    @Test func initWithDateAndCalendarInvalidHours() throws {
        let calendar = Calendar.current
        let invalidDate = calendar.date(from: DateComponents(year: 2024, month: 1, day: 15, hour: 2))!
        
        let timePeriod = TimePeriod(date: invalidDate, calendar: calendar)
        
        #expect(timePeriod == nil)
    }
    
    @Test(arguments: zip([TimeOfDay.morning, .afternoon, .evening], [TimeOfDay.afternoon, .evening, .morning]))
    func next(_ fromTimeOfDay: TimeOfDay, expectedNextTimeOfDay: TimeOfDay) throws {
        let calendar = Calendar.current
        let date = Date().startOfDay()
        let period = TimePeriod.createStub(date: date, timeOfDay: fromTimeOfDay)
        
        let nextPeriod = period.next(calendar: calendar)
        
        if fromTimeOfDay == .evening {
            let expectedNextDay = calendar.date(byAdding: .day, value: 1, to: date) ?? date
            #expect(nextPeriod.date == expectedNextDay)
        } else {
            #expect(nextPeriod.date == date)
        }
        #expect(nextPeriod.timeOfDay == expectedNextTimeOfDay)
    }
    
    @Test func compareDifferentDates() throws {
        let calendar = Calendar.current
        let earlierDate = calendar.date(from: DateComponents(year: 2024, month: 1, day: 15))!
        let laterDate = calendar.date(from: DateComponents(year: 2024, month: 1, day: 16))!
        
        let earlierPeriod = TimePeriod.createStub(date: earlierDate, timeOfDay: .evening)
        let laterPeriod = TimePeriod.createStub(date: laterDate, timeOfDay: .morning)
        
        #expect(earlierPeriod < laterPeriod)
        #expect(laterPeriod > earlierPeriod)
    }
    
    @Test func compareSameDateDifferentTimeOfDay() throws {
        let morningPeriod = TimePeriod.createStub(timeOfDay: .morning)
        let afternoonPeriod = TimePeriod.createStub(timeOfDay: .afternoon)
        let eveningPeriod = TimePeriod.createStub(timeOfDay: .evening)
        
        #expect(morningPeriod == morningPeriod)
        #expect(morningPeriod < afternoonPeriod)
        #expect(afternoonPeriod < eveningPeriod)
        #expect(morningPeriod < eveningPeriod)
        #expect(eveningPeriod > afternoonPeriod)
        #expect(afternoonPeriod > morningPeriod)
    }
} 
