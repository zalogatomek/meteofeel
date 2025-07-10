import Foundation

struct WeatherResponse: Codable {
    let location: Location?
    let current: Current?
    let forecast: Forecast?
    
    struct Location: Codable {
        let name: String?
        let region: String?
        let country: String?
        let lat: Double?
        let lon: Double?
        let localtime: String?
    }
    
    struct Current: Codable {
        let tempC: Double?
        let isDay: Int?
        let condition: Condition?
        let windKph: Double?
        let windDegree: Int?
        let windDir: String?
        let pressureMb: Double?
        let precipMm: Double?
        let humidity: Int?
        let cloud: Int?
        let feelslikeC: Double?
        let visKm: Double?
        let uv: Double?
        let gustKph: Double?
        let airQuality: AirQuality?
    }
    
    struct Condition: Codable {
        let text: String?
        let icon: String?
        let code: Int?
    }
    
    struct AirQuality: Codable {
        let co: Double?
        let no2: Double?
        let o3: Double?
        let so2: Double?
        let pm2_5: Double?
        let pm10: Double?
        let usEpaIndex: Int?
        let gbDefraIndex: Int?
    }
    
    struct Forecast: Codable {
        let forecastday: [ForecastDay]?
    }
    
    struct ForecastDay: Codable {
        let date: String?
        let day: Day?
        let astro: Astro?
        let hour: [Hour]?
    }
    
    struct Day: Codable {
        let maxtempC: Double?
        let mintempC: Double?
        let avgtempC: Double?
        let maxwindKph: Double?
        let totalprecipMm: Double?
        let totalsnowCm: Double?
        let avghumidity: Double?
        let dailyWillItRain: Int?
        let dailyChanceOfRain: Int?
        let dailyWillItSnow: Int?
        let dailyChanceOfSnow: Int?
        let condition: Condition?
        let uv: Double?
        let airQuality: AirQuality?
    }
    
    struct Astro: Codable {
        let sunrise: String?
        let sunset: String?
        let moonrise: String?
        let moonset: String?
        let moonPhase: String?
        let moonIllumination: Int?
        let isMoonUp: Int?
        let isSunUp: Int?
    }
    
    struct Hour: Codable {
        let timeEpoch: Int?
        let time: String?
        let tempC: Double?
        let isDay: Int?
        let condition: Condition?
        let windKph: Double?
        let windDegree: Int?
        let windDir: String?
        let pressureMb: Double?
        let precipMm: Double?
        let humidity: Int?
        let cloud: Int?
        let feelslikeC: Double?
        let willItRain: Int?
        let chanceOfRain: Int?
        let willItSnow: Int?
        let chanceOfSnow: Int?
        let visKm: Double?
        let gustKph: Double?
        let uv: Double?
        let airQuality: AirQuality?
    }
} 
