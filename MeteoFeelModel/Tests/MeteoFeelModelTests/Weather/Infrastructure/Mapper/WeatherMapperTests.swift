import Foundation
import Testing
@testable import MeteoFeelModel

final class WeatherMapperTests {
    
    // MARK: - Tests - Successful Mapping
    
    @Test
    func mapsResponseWithValidForecastDay() throws {
        let response = WeatherResponse.createStub(
            forecast: .createStub(
                forecastday: [
                    .createStub(
                        date: "2024-01-15",
                        hour: [
                            .createStub(time: "2024-01-15 08:00", tempC: 15.0, condition: .createStub(code: 1000), windKph: 10.0, windDegree: 180, pressureMb: 1010.0, humidity: 70), // Morning
                            .createStub(time: "2024-01-15 14:00", tempC: 25.0, condition: .createStub(code: 1003), windKph: 15.0, windDegree: 200, pressureMb: 1015.0, humidity: 60), // Afternoon
                            .createStub(time: "2024-01-15 20:00", tempC: 18.0, condition: .createStub(code: 1006), windKph: 12.0, windDegree: 190, pressureMb: 1012.0, humidity: 75)  // Evening
                        ]
                    )
                ]
            )
        )
        
        let result = try #require(WeatherMapper.map(response))
        
        #expect(result.count == 3)
        
        let morningWeather = try #require(result.first { $0.timePeriod.timeOfDay == TimeOfDay.morning })
        let afternoonWeather = try #require(result.first { $0.timePeriod.timeOfDay == TimeOfDay.afternoon })
        let eveningWeather = try #require(result.first { $0.timePeriod.timeOfDay == TimeOfDay.evening })
        
        #expect(morningWeather.temperature == 15.0)
        #expect(morningWeather.pressure == 1010.0)
        #expect(morningWeather.humidity == 70.0)
        #expect(morningWeather.windSpeed == 10.0)
        #expect(morningWeather.windDirection == 180.0)
        #expect(morningWeather.condition == WeatherCondition.sunny)
        
        #expect(afternoonWeather.temperature == 25.0)
        #expect(afternoonWeather.pressure == 1015.0)
        #expect(afternoonWeather.humidity == 60.0)
        #expect(afternoonWeather.windSpeed == 15.0)
        #expect(afternoonWeather.windDirection == 200.0)
        #expect(afternoonWeather.condition == WeatherCondition.partlyCloudy)
        
        #expect(eveningWeather.temperature == 18.0)
        #expect(eveningWeather.pressure == 1012.0)
        #expect(eveningWeather.humidity == 75.0)
        #expect(eveningWeather.windSpeed == 12.0)
        #expect(eveningWeather.windDirection == 190.0)
        #expect(eveningWeather.condition == WeatherCondition.cloudy)
    }
    
    @Test(arguments: [
        (1000, WeatherCondition.sunny),
        (1003, WeatherCondition.partlyCloudy),
        (1006, WeatherCondition.cloudy),
        (1030, WeatherCondition.foggy),
        (1063, WeatherCondition.rainy),
        (1180, WeatherCondition.heavyRain),
        (1066, WeatherCondition.snowy),
        (1087, WeatherCondition.thunderstorm),
        (1168, WeatherCondition.windy),
        (9999, WeatherCondition.unknown)
    ])
    func mapsWeatherCondition(code: Int, expected: WeatherCondition) throws {
        let response = WeatherResponse.createStub(
            forecast: .createStub(
                forecastday: [
                    .createStub(
                        hour: [
                            .createStub(
                                condition: .createStub(code: code)
                            )
                        ]
                    )
                ]
            )
        )
        
        let weather = try #require(WeatherMapper.map(response)?.first)
        
        #expect(weather.condition == expected)
    }
    
    @Test(arguments: [
        (0, nil),
        (2, nil),
        (5, nil),
        (6, TimeOfDay.morning),
        (8, TimeOfDay.morning),
        (11, TimeOfDay.morning),
        (12, TimeOfDay.afternoon),
        (14, TimeOfDay.afternoon),
        (17, TimeOfDay.afternoon),
        (18, TimeOfDay.evening),
        (20, TimeOfDay.evening),
        (23, TimeOfDay.evening)
    ])
    func mapsTimeOfDay(hour: Int, expected: TimeOfDay?) throws {
        let response = WeatherResponse.createStub(
            forecast: .createStub(
                forecastday: [
                    .createStub(
                        hour: [
                            .createStub(
                                time: "2024-01-15 \(String(format: "%02d", hour)):00"
                            )
                        ]
                    )
                ]
            )
        )
        
        let weather = WeatherMapper.map(response)?.first
        
        #expect(weather?.timePeriod.timeOfDay == expected)
    }
    
    // MARK: - Tests - Missing Data Handling
    
    @Test(arguments: [
        nil,
        WeatherResponse.Forecast.createStub(forecastday: [])
    ])
    func returnsNilWhenForecastIsMissingOrEmpty(forecast: WeatherResponse.Forecast?) throws {
        let response = WeatherResponse.createStub(forecast: forecast)
        
        let result = WeatherMapper.map(response)
        
        #expect(result == nil)
    }
    
    // MARK: - Tests - Aggregation Logic
    
    @Test
    func aggregatesMultipleHoursCorrectly() throws {
        let response = WeatherResponse.createStub(
            forecast: .createStub(
                forecastday: [
                    .createStub(
                        date: "2024-01-15",
                        hour: [
                            .createStub(time: "2024-01-15 08:00", tempC: 10.0, condition: .createStub(code: 1000), windKph: 10.0, windDegree: 180, pressureMb: 1011.0, humidity: 60),
                            .createStub(time: "2024-01-15 09:00", tempC: 12.0, condition: .createStub(code: 1003), windKph: 12.0, windDegree: 185, pressureMb: 1012.0, humidity: 65),
                            .createStub(time: "2024-01-15 10:00", tempC: 17.0, condition: .createStub(code: 1006), windKph: 14.0, windDegree: 190, pressureMb: 1016.0, humidity: 70)
                        ]
                    )
                ]
            )
        )
        
        let result = try #require(WeatherMapper.map(response))
        let weather = try #require(result.first)
        
        #expect(weather.temperature == 13.0)    // (10 + 12 + 17) / 3
        #expect(weather.pressure == 1013.0)     // (1011 + 1012 + 1016) / 3
        #expect(weather.humidity == 65.0)       // (60 + 65 + 70) / 3
        #expect(weather.windSpeed == 12.0)      // (10 + 12 + 14) / 3
        #expect(weather.windDirection == 185.0) // (180 + 185 + 190) / 3
    }
    
    @Test(arguments: [
        ([1000, 1003, 1087], WeatherCondition.thunderstorm),    // sunny, partlyCloudy, thunderstorm -> thunderstorm (severity 5)
        ([1000, 1030, 1063], WeatherCondition.rainy),           // sunny, foggy, rainy -> rainy (severity 3)
        ([1000, 1063, 1180], WeatherCondition.heavyRain),       // sunny, rainy, heavyRain -> heavyRain (severity 4)
        ([1000, 1006, 1168], WeatherCondition.windy),           // sunny, cloudy, windy -> windy (severity 2)
        ([1000, 1030, 1066], WeatherCondition.snowy),           // sunny, foggy, snowy -> snowy (severity 3)
        ([1000, 1003, 1006], WeatherCondition.partlyCloudy),    // sunny, partlyCloudy, cloudy -> partlyCloudy (same severity 1, first wins)
        ([1000, 1006, 1003], WeatherCondition.cloudy),          // sunny, cloudy, partlyCloudy -> cloudy (same severity 1, first wins)
        ([1000, 1003, 1000], WeatherCondition.partlyCloudy),    // sunny, partlyCloudy, sunny -> partlyCloudy (severity 1 > 0)
        ([1000, 1000, 1000], WeatherCondition.sunny),           // all sunny -> sunny (severity 0)
        ([1087, 1180, 1063], WeatherCondition.thunderstorm),    // thunderstorm, heavyRain, rainy -> thunderstorm (severity 5)
        ([1066, 1168, 1030], WeatherCondition.snowy),           // snowy, windy, foggy -> snowy (severity 3 > 2)
        ([9999, 1000, 1003], WeatherCondition.partlyCloudy)     // unknown, sunny, partlyCloudy -> partlyCloudy (severity 1 > 0)
    ])
    func selectsMostSevereWeatherCondition(codes: [Int], expected: WeatherCondition) throws {
        let response = WeatherResponse.createStub(
            forecast: .createStub(
                forecastday: [
                    .createStub(
                        date: "2024-01-15",
                        hour: [
                            .createStub(time: "2024-01-15 08:00", condition: .createStub(code: codes[0])),
                            .createStub(time: "2024-01-15 09:00", condition: .createStub(code: codes[1])),
                            .createStub(time: "2024-01-15 10:00", condition: .createStub(code: codes[2]))
                        ]
                    )
                ]
            )
        )
        
        let result = try #require(WeatherMapper.map(response))
        let weather = try #require(result.first)
        
        #expect(weather.condition == expected)
    }
} 