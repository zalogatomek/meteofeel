import Foundation
import Testing
@testable import MeteoFeelModel

struct WeatherForecastTests {

    // MARK: - Tests
    
    @Test 
    func initializesWithWeatherAndAlerts() throws {
        let weather = Weather.createStub()
        let alerts = [HealthAlert.createStub()]
        
        let forecast = WeatherForecast.createStub(weather: weather, alerts: alerts)
        
        #expect(forecast.weather == weather)
        #expect(forecast.alerts == alerts)
        #expect(forecast.id != UUID())
    }
    
    @Test 
    func byFilteringHealthIssuesReturnsSameWhenEmptySet() throws {
        let weather = Weather.createStub()
        let alerts = [HealthAlert.createStub()]
        
        let forecast = WeatherForecast.createStub(weather: weather, alerts: alerts)
        let filtered = forecast.byFilteringHealthIssues([])
        
        #expect(filtered.weather == weather)
        #expect(filtered.alerts == alerts)
    }
    
    @Test 
    func byFilteringHealthIssuesFiltersMatchingIssues() throws {
        let weather = Weather.createStub()
        
        let headacheAlert = HealthAlert.createStub(
            healthIssue: .headache,
            parameter: .temperature,
            value: 25.0,
            risk: .medium
        )
        
        let jointPainAlert = HealthAlert.createStub(
            timePeriod: TimePeriod.createStub(timeOfDay: .afternoon),
            healthIssue: .jointPain,
            parameter: .humidity,
            value: 80.0,
            risk: .high
        )
        
        let alerts = [headacheAlert, jointPainAlert]
        let forecast = WeatherForecast.createStub(weather: weather, alerts: alerts)
        
        let filtered = forecast.byFilteringHealthIssues([HealthIssue.headache])
        
        #expect(filtered.weather == weather)
        #expect(filtered.alerts.count == 1)
        #expect(filtered.alerts.first?.pattern.healthIssue == .headache)
    }
    
    @Test 
    func byFilteringHealthIssuesFiltersMultipleIssues() throws {
        let weather = Weather.createStub()
        
        let headacheAlert = HealthAlert.createStub(
            healthIssue: .headache,
            parameter: .temperature,
            value: 25.0,
            risk: .medium
        )
        
        let jointPainAlert = HealthAlert.createStub(
            timePeriod: TimePeriod.createStub(timeOfDay: .afternoon),
            healthIssue: .jointPain,
            parameter: .humidity,
            value: 80.0,
            risk: .high
        )
        
        let respiratoryAlert = HealthAlert.createStub(
            timePeriod: TimePeriod.createStub(timeOfDay: .evening),
            healthIssue: .respiratory,
            condition: .below,
            parameter: .pressure,
            value: 1000.0,
            risk: .medium
        )
        
        let alerts = [headacheAlert, jointPainAlert, respiratoryAlert]
        let forecast = WeatherForecast.createStub(weather: weather, alerts: alerts)
        
        let filtered = forecast.byFilteringHealthIssues([HealthIssue.headache, HealthIssue.jointPain])
        
        #expect(filtered.weather == weather)
        #expect(filtered.alerts.count == 2)
        #expect(filtered.alerts.contains { $0.pattern.healthIssue == .headache })
        #expect(filtered.alerts.contains { $0.pattern.healthIssue == .jointPain })
        #expect(!filtered.alerts.contains { $0.pattern.healthIssue == .respiratory })
    }
} 