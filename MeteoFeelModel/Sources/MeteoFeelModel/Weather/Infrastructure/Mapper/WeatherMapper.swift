import Foundation

enum WeatherMapper {

    // MARK: - Static Properties
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    // MARK: - Map
    
    static func map(_ response: WeatherResponse) -> [Weather]? {
        guard let forecast = response.forecast,
              let forecastDays = forecast.forecastday,
              !forecastDays.isEmpty
        else { return nil }
        
        var weathers: [Weather] = []
        
        for day in forecastDays {
            guard let hours = day.hour,
                  let dateString = day.date,
                  let date = dateFormatter.date(from: dateString)
            else { continue }
            
            // Group hours by time of day
            let morningHours = hours.filter { hour in
                guard let time = hour.time,
                      let hourInt = Int(time.split(separator: " ").last?.split(separator: ":").first ?? "") 
                else { return false }
                return mapTimeOfDay(hour: hourInt) == .morning
            }
            
            let afternoonHours = hours.filter { hour in
                guard let time = hour.time,
                      let hourInt = Int(time.split(separator: " ").last?.split(separator: ":").first ?? "") 
                else { return false }
                return mapTimeOfDay(hour: hourInt) == .afternoon
            }
            
            let eveningHours = hours.filter { hour in
                guard let time = hour.time,
                      let hourInt = Int(time.split(separator: " ").last?.split(separator: ":").first ?? "") 
                else { return false }
                return mapTimeOfDay(hour: hourInt) == .evening
            }
            
            // Map each time period
            if let morningWeather = aggregateWeather(for: morningHours, date: date, timeOfDay: .morning) {
                weathers.append(morningWeather)
            }
            
            if let afternoonWeather = aggregateWeather(for: afternoonHours, date: date, timeOfDay: .afternoon) {
                weathers.append(afternoonWeather)
            }
            
            if let eveningWeather = aggregateWeather(for: eveningHours, date: date, timeOfDay: .evening) {
                weathers.append(eveningWeather)
            }
        }
        
        return weathers.isEmpty ? nil : weathers
    }
    
    // MARK: - Helpers
    
    private static func mapTimeOfDay(hour: Int) -> TimeOfDay? {
        switch hour {
        case 6..<12: .morning
        case 12..<18: .afternoon
        case 18..<24: .evening
        default: nil
        }
    }
    
    private static func mapWeatherCondition(_ code: Int) -> WeatherCondition {
        switch code {
        case 1000: .sunny
        case 1003: .partlyCloudy
        case 1006, 1009: .cloudy
        case 1030, 1135, 1147: .foggy
        case 1063, 1150, 1153: .rainy
        case 1180, 1183, 1186, 1189, 1192, 1195, 1204, 1207, 1240, 1243, 1246: .heavyRain
        case 1066, 1069, 1072, 1114, 1201, 1210, 1213, 1216, 1219, 1222, 1225, 1237, 1249, 1252, 1255, 1258, 1261, 1264: .snowy
        case 1087, 1273, 1276: .thunderstorm
        case 1168, 1171: .windy
        default: .unknown
        }
    }
    
    private static func aggregateWeather(for hours: [WeatherResponse.Hour], date: Date, timeOfDay: TimeOfDay) -> Weather? {
        guard !hours.isEmpty else { return nil }
        
        let temperatures = hours.compactMap { $0.tempC }
        let pressures = hours.compactMap { $0.pressureMb }
        let humidities = hours.compactMap { $0.humidity }
        let windSpeeds = hours.compactMap { $0.windKph }
        let windDegrees = hours.compactMap { $0.windDegree }
        let conditions = hours.compactMap { $0.condition?.code }.compactMap { mapWeatherCondition($0) }
        
        guard !temperatures.isEmpty,
              !pressures.isEmpty,
              !humidities.isEmpty,
              !windSpeeds.isEmpty,
              !windDegrees.isEmpty,
              !conditions.isEmpty
        else { return nil }
        
        let avgTemp = temperatures.reduce(0, +) / Double(temperatures.count)
        let avgPressure = pressures.reduce(0, +) / Double(pressures.count)
        let avgHumidity = Double(humidities.reduce(0, +)) / Double(humidities.count)
        let avgWindSpeed = windSpeeds.reduce(0, +) / Double(windSpeeds.count)
        let avgWindDegree = Double(windDegrees.reduce(0, +)) / Double(windDegrees.count)
        
        let mostSevereCondition = conditions.max { a, b in
            severity(of: a) < severity(of: b)
        } ?? .unknown
        
        return Weather(
            condition: mostSevereCondition,
            temperature: avgTemp,
            pressure: avgPressure,
            humidity: avgHumidity,
            windSpeed: avgWindSpeed,
            windDirection: avgWindDegree,
            timePeriod: TimePeriod(date: date, timeOfDay: timeOfDay)
        )
    }
    
    private static func severity(of condition: WeatherCondition) -> Int {
        switch condition {
        case .thunderstorm: 5
        case .heavyRain: 4
        case .rainy: 3
        case .snowy: 3
        case .windy: 2
        case .foggy: 2
        case .cloudy: 1
        case .partlyCloudy: 1
        case .sunny: 0
        case .unknown: 0
        }
    }
} 
