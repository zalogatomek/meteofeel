import Foundation
import Testing
@testable import MeteoFeelUtilities

struct DateDayTests {
    
    // MARK: - Tests - isToday
    
    @Test(arguments: [
        Date(),
        Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date())!,
        Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!
    ])
    func isToday(_ date: Date) throws {
        #expect(date.isToday)
    }

    @Test(arguments: [
        Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
        Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    ])
    func isNotToday(_ date: Date) throws {
        #expect(!date.isToday)
    }
    
    // MARK: - Tests - isYesterday
    
    @Test(arguments: [
        Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
        Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)!,
        Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)!
    ])
    func isYesterday(_ date: Date) throws {
        #expect(date.isYesterday)
    }

    @Test(arguments: [
        Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
        Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    ])
    func isNotYesterday(_ date: Date) throws {
        #expect(!date.isYesterday)
    }
    
    // MARK: - Tests - isTomorrow

    @Test(arguments: [
        Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
        Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)!,
        Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)!
    ])
    func isTomorrow(_ date: Date) throws {
        #expect(date.isTomorrow)
    }

    @Test(arguments: [
        Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
        Calendar.current.date(byAdding: .day, value: 2, to: Date())!
    ])
    func isNotTomorrow(_ date: Date) throws {
        #expect(!date.isTomorrow)
    }
    
    // MARK: - Tests - isInFuture
    
    @Test(arguments: [
        Calendar.current.date(byAdding: .second, value: 1, to: Date())!,
        Calendar.current.date(byAdding: .minute, value: 1, to: Date())!,
        Calendar.current.date(byAdding: .hour, value: 1, to: Date())!,
        Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
        Date.distantFuture
    ])
    func isInFuture(_ date: Date) throws {
        #expect(date.isInFuture)
    }

    @Test(arguments: [
        Date.distantPast,
        Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
        Calendar.current.date(byAdding: .hour, value: -1, to: Date())!,
        Calendar.current.date(byAdding: .minute, value: -1, to: Date())!,
        Calendar.current.date(byAdding: .second, value: -1, to: Date())!,
        Date()
    ])
    func isNotInFuture(_ date: Date) throws {
        #expect(!date.isInFuture)
    }
    
    // MARK: - Tests - boundary conditions
    
    @Test 
    func boundaryConditionsWithStartOfDay() throws {
        let today = Date()
        let startOfDay = Calendar.current.startOfDay(for: today)
        
        #expect(startOfDay.isToday)
        #expect(!startOfDay.isYesterday)
        #expect(!startOfDay.isTomorrow)
    }
    
    @Test 
    func boundaryConditionsWithEndOfDay() throws {
        let today = Date()
        let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: today)!
        
        #expect(endOfDay.isToday)
        #expect(!endOfDay.isYesterday)
        #expect(!endOfDay.isTomorrow)
    }
} 
