import Foundation
import Testing
@testable import MeteoFeelModel

struct WeatherConditionTests {

    // MARK: - Tests
    
    @Test func initWithValidRawValues() throws {
        let sunny = WeatherCondition(value: 0)
        let partlyCloudy = WeatherCondition(value: 1)
        let cloudy = WeatherCondition(value: 2)
        let rainy = WeatherCondition(value: 3)
        let heavyRain = WeatherCondition(value: 4)
        let snowy = WeatherCondition(value: 5)
        let foggy = WeatherCondition(value: 6)
        let windy = WeatherCondition(value: 7)
        let thunderstorm = WeatherCondition(value: 8)
        
        #expect(sunny == .sunny)
        #expect(partlyCloudy == .partlyCloudy)
        #expect(cloudy == .cloudy)
        #expect(rainy == .rainy)
        #expect(heavyRain == .heavyRain)
        #expect(snowy == .snowy)
        #expect(foggy == .foggy)
        #expect(windy == .windy)
        #expect(thunderstorm == .thunderstorm)
    }
    
    @Test func initWithInvalidRawValuesReturnsUnknown() throws {
        let negativeOne = WeatherCondition(value: -1)
        let invalidPositive = WeatherCondition(value: 999)
        let invalidNegative = WeatherCondition(value: -999)
        let maxDouble = WeatherCondition(value: Double.greatestFiniteMagnitude)
        let minDouble = WeatherCondition(value: -Double.greatestFiniteMagnitude)
        let infinity = WeatherCondition(value: Double.infinity)
        let negativeInfinity = WeatherCondition(value: -Double.infinity)
        let nan = WeatherCondition(value: Double.nan)
        
        #expect(negativeOne == .unknown)
        #expect(invalidPositive == .unknown)
        #expect(invalidNegative == .unknown)
        #expect(maxDouble == .unknown)
        #expect(minDouble == .unknown)
        #expect(infinity == .unknown)
        #expect(negativeInfinity == .unknown)
        #expect(nan == .unknown)
    }
    
    @Test func initWithDecimalValuesRoundsToInteger() throws {
        let sunnyDecimal = WeatherCondition(value: 0.5)
        let partlyCloudyDecimal = WeatherCondition(value: 1.7)
        let invalidDecimal = WeatherCondition(value: 999.9)
        
        #expect(sunnyDecimal == .sunny)
        #expect(partlyCloudyDecimal == .partlyCloudy)
        #expect(invalidDecimal == .unknown)
    }
} 