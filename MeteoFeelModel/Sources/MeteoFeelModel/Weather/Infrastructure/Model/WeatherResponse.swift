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

extension WeatherResponse {
    
    // MARK: - Stubs
    
    static func createStub(
        location: Location? = .createStub(),
        current: Current? = .createStub(),
        forecast: Forecast? = .createStub()
    ) -> WeatherResponse {
        WeatherResponse(location: location, current: current, forecast: forecast)
    }
}

extension WeatherResponse.Location {
    
    // MARK: - Stubs
    
    static func createStub(
        name: String? = "London",
        region: String? = "England",
        country: String? = "United Kingdom",
        lat: Double? = 51.5074,
        lon: Double? = -0.1278,
        localtime: String? = "2024-01-15 12:00"
    ) -> WeatherResponse.Location {
        WeatherResponse.Location(
            name: name,
            region: region,
            country: country,
            lat: lat,
            lon: lon,
            localtime: localtime
        )
    }
}

extension WeatherResponse.Current {
    
    // MARK: - Stubs
    
    static func createStub(
        tempC: Double? = 20.0,
        isDay: Int? = 1,
        condition: WeatherResponse.Condition? = .createStub(),
        windKph: Double? = 15.0,
        windDegree: Int? = 180,
        windDir: String? = "S",
        pressureMb: Double? = 1013.0,
        precipMm: Double? = 0.0,
        humidity: Int? = 65,
        cloud: Int? = 50,
        feelslikeC: Double? = 19.0,
        visKm: Double? = 10.0,
        uv: Double? = 5.0,
        gustKph: Double? = 25.0,
        airQuality: WeatherResponse.AirQuality? = .createStub()
    ) -> WeatherResponse.Current {
        WeatherResponse.Current(
            tempC: tempC,
            isDay: isDay,
            condition: condition,
            windKph: windKph,
            windDegree: windDegree,
            windDir: windDir,
            pressureMb: pressureMb,
            precipMm: precipMm,
            humidity: humidity,
            cloud: cloud,
            feelslikeC: feelslikeC,
            visKm: visKm,
            uv: uv,
            gustKph: gustKph,
            airQuality: airQuality
        )
    }
}

extension WeatherResponse.Condition {
    
    // MARK: - Stubs
    
    static func createStub(
        text: String? = "Partly cloudy",
        icon: String? = "//cdn.weatherapi.com/weather/64x64/day/116.png",
        code: Int? = 1003
    ) -> WeatherResponse.Condition {
        WeatherResponse.Condition(text: text, icon: icon, code: code)
    }
}

extension WeatherResponse.AirQuality {
    
    // MARK: - Stubs
    
    static func createStub(
        co: Double? = 200.0,
        no2: Double? = 15.0,
        o3: Double? = 45.0,
        so2: Double? = 5.0,
        pm2_5: Double? = 12.0,
        pm10: Double? = 25.0,
        usEpaIndex: Int? = 2,
        gbDefraIndex: Int? = 3
    ) -> WeatherResponse.AirQuality {
        WeatherResponse.AirQuality(
            co: co,
            no2: no2,
            o3: o3,
            so2: so2,
            pm2_5: pm2_5,
            pm10: pm10,
            usEpaIndex: usEpaIndex,
            gbDefraIndex: gbDefraIndex
        )
    }
}

extension WeatherResponse.Forecast {
    
    // MARK: - Stubs
    
    static func createStub(
        forecastday: [WeatherResponse.ForecastDay]? = [.createStub()]
    ) -> WeatherResponse.Forecast {
        WeatherResponse.Forecast(forecastday: forecastday)
    }
}

extension WeatherResponse.ForecastDay {
    
    // MARK: - Stubs
    
    static func createStub(
        date: String? = "2024-01-15",
        day: WeatherResponse.Day? = .createStub(),
        astro: WeatherResponse.Astro? = .createStub(),
        hour: [WeatherResponse.Hour]? = [.createStub()]
    ) -> WeatherResponse.ForecastDay {
        WeatherResponse.ForecastDay(date: date, day: day, astro: astro, hour: hour)
    }
}

extension WeatherResponse.Day {
    
    // MARK: - Stubs
    
    static func createStub(
        maxtempC: Double? = 25.0,
        mintempC: Double? = 15.0,
        avgtempC: Double? = 20.0,
        maxwindKph: Double? = 20.0,
        totalprecipMm: Double? = 5.0,
        totalsnowCm: Double? = 0.0,
        avghumidity: Double? = 70.0,
        dailyWillItRain: Int? = 1,
        dailyChanceOfRain: Int? = 60,
        dailyWillItSnow: Int? = 0,
        dailyChanceOfSnow: Int? = 0,
        condition: WeatherResponse.Condition? = .createStub(),
        uv: Double? = 6.0,
        airQuality: WeatherResponse.AirQuality? = .createStub()
    ) -> WeatherResponse.Day {
        WeatherResponse.Day(
            maxtempC: maxtempC,
            mintempC: mintempC,
            avgtempC: avgtempC,
            maxwindKph: maxwindKph,
            totalprecipMm: totalprecipMm,
            totalsnowCm: totalsnowCm,
            avghumidity: avghumidity,
            dailyWillItRain: dailyWillItRain,
            dailyChanceOfRain: dailyChanceOfRain,
            dailyWillItSnow: dailyWillItSnow,
            dailyChanceOfSnow: dailyChanceOfSnow,
            condition: condition,
            uv: uv,
            airQuality: airQuality
        )
    }
}

extension WeatherResponse.Astro {
    
    // MARK: - Stubs
    
    static func createStub(
        sunrise: String? = "07:30 AM",
        sunset: String? = "04:30 PM",
        moonrise: String? = "08:00 PM",
        moonset: String? = "09:00 AM",
        moonPhase: String? = "Waxing Crescent",
        moonIllumination: Int? = 25,
        isMoonUp: Int? = 0,
        isSunUp: Int? = 1
    ) -> WeatherResponse.Astro {
        WeatherResponse.Astro(
            sunrise: sunrise,
            sunset: sunset,
            moonrise: moonrise,
            moonset: moonset,
            moonPhase: moonPhase,
            moonIllumination: moonIllumination,
            isMoonUp: isMoonUp,
            isSunUp: isSunUp
        )
    }
}

extension WeatherResponse.Hour {
    
    // MARK: - Stubs
    
    static func createStub(
        timeEpoch: Int? = 1705312800,
        time: String? = "2024-01-15 12:00",
        tempC: Double? = 20.0,
        isDay: Int? = 1,
        condition: WeatherResponse.Condition? = .createStub(),
        windKph: Double? = 15.0,
        windDegree: Int? = 180,
        windDir: String? = "S",
        pressureMb: Double? = 1013.0,
        precipMm: Double? = 0.0,
        humidity: Int? = 65,
        cloud: Int? = 50,
        feelslikeC: Double? = 19.0,
        willItRain: Int? = 0,
        chanceOfRain: Int? = 20,
        willItSnow: Int? = 0,
        chanceOfSnow: Int? = 0,
        visKm: Double? = 10.0,
        gustKph: Double? = 25.0,
        uv: Double? = 5.0,
        airQuality: WeatherResponse.AirQuality? = .createStub()
    ) -> WeatherResponse.Hour {
        WeatherResponse.Hour(
            timeEpoch: timeEpoch,
            time: time,
            tempC: tempC,
            isDay: isDay,
            condition: condition,
            windKph: windKph,
            windDegree: windDegree,
            windDir: windDir,
            pressureMb: pressureMb,
            precipMm: precipMm,
            humidity: humidity,
            cloud: cloud,
            feelslikeC: feelslikeC,
            willItRain: willItRain,
            chanceOfRain: chanceOfRain,
            willItSnow: willItSnow,
            chanceOfSnow: chanceOfSnow,
            visKm: visKm,
            gustKph: gustKph,
            uv: uv,
            airQuality: airQuality
        )
    }
} 
