import UIKit

fileprivate func dropTime(_ dt: Int) -> Int{
    return dt - dt % Int(86400)
}

fileprivate func returnHour(_ dt: Int) -> Int{
    return ( dt % Int(86400) ) / 3600
}

fileprivate func formatDate(_ time: Int) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMMM, E"
    formatter.locale = Locale(identifier: "ru_RU")
    
    return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(dropTime(time)))).lowercased()
}

fileprivate func formatTemperature(_ dayItem: [ForecastHourCodable]) -> String {
    return String( Int( dayItem.map( { Int($0.main.temp) } ).reduce(0, +) / dayItem.count ) ) + "°"
}

fileprivate func formatTemperatureFeelsLike(_ dayItem: [ForecastHourCodable]) -> String {
    return String( Int( dayItem.map( { Int($0.main.feelsLike) } ).reduce(0, +) / dayItem.count ) ) + "°"
}

fileprivate func formatWind(_ dayItem: [ForecastHourCodable]) -> String {
    let value = dayItem.map( { Float($0.wind.speed) } ).reduce(0, +) / Float(dayItem.count)
    return String(format: "%.1fм/с", value )
}

fileprivate func formatHumidity(_ dayItem: [ForecastHourCodable]) -> String {
    return String( Int( dayItem.map( { $0.main.humidity } ).reduce(0, +) / dayItem.count ) ) + "%"
}

fileprivate func formatPrecipitation(_ dayItem: [ForecastHourCodable]) -> String{
    let value = dayItem.map( { Float($0.rain?.the3H ?? 0) } ).reduce(0, +) / Float(dayItem.count)
    return String(format: "%.2fмм", value )
}

fileprivate func getAverageImageSet(_ dayItem: [ForecastHourCodable]) -> [UIImage] {
    return ImageManager.getIconAnimateByCode(
        Dictionary( grouping: dayItem, by: { $0.weather[0].icon })
            .sorted( by: { $0.value.count > $1.value.count } )
            .first?.value[0].weather[0].icon ?? "" )
}

fileprivate func getDescription(_ dayItem: [ForecastHourCodable]) -> String{
    return Dictionary(
        grouping: dayItem,
        by: { $0.weather[0].weatherDescription })
        .sorted(by: { $0.value.count > $1.value.count })
        .first?.value[0].weather[0].weatherDescription ?? ""
}

fileprivate func createHour(_ hourItem: ForecastHourCodable) -> ForecastHour {
    return ForecastHour(
        temperature: String( Int( hourItem.main.temp ) ) + "°",
        tempValue: Double(hourItem.main.temp),
        feelsLike: String( Int( hourItem.main.feelsLike ) ) + "°",
        icon: ImageManager.getIconByCode( hourItem.weather[0].icon ),
        hour: String( returnHour(hourItem.dt) ) + ":00",
        hourValue: returnHour(hourItem.dt)
    )
}

fileprivate func createDay(_ dayItem: [ForecastHourCodable], hours: [ForecastHour]) -> ForecastDay{
    return ForecastDay(
        temperature: formatTemperature(dayItem),
        feelsLike: formatTemperatureFeelsLike(dayItem),
        icon: getAverageImageSet(dayItem),
        date: formatDate(dayItem[0].dt),
        description: getDescription(dayItem) + ", ощущается как " + formatTemperatureFeelsLike(dayItem),
        forecast: hours,
        wind: formatWind(dayItem),
        humidity: formatHumidity(dayItem),
        precipitation: formatPrecipitation(dayItem)
    )
}

fileprivate func groupForecastByDays(_ forecast: [ForecastHourCodable]) -> [[ForecastHourCodable]] {
    return Array(Dictionary(grouping: forecast, by: { dropTime($0.dt) } ).values)
        .sorted(by: { $0[0].dt < $1[0].dt } )
}

struct ForecastCodable: Codable {
    var missing: [MissingForecastHourCodable]?
    let list: [ForecastHourCodable]
    let city: CityCodable
}

struct CityCodable: Codable {
    let name: String
    let coord: CoordCodable
    let country: String
    let population: Int
}

struct CoordCodable: Codable {
    let lat, lon: Double
}

struct ForecastHourCodable: Codable {
    let dt: Int
    let main: MainDetailsCodable
    let weather: [WeatherCodable]
    let wind: WindCodable
    let rain: RainCodable?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, wind
        case rain = "rain"
    }
}

struct MainDetailsCodable: Codable {
    let temp, feelsLike: Float
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case humidity
    }
}

struct RainCodable: Codable {
    let the3H: Float

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

struct WeatherCodable: Codable {
    let weatherDescription: String!
    let icon: String

    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon = "icon"
    }
}

struct WindCodable: Codable {
    let speed: Float
}

struct MissingForecastCodable: Codable {
    let hourly: [MissingForecastHourCodable]

    enum CodingKeys: String, CodingKey {
        case hourly
    }
}

struct MissingForecastHourCodable: Codable {
    let date: Int
    let temperature: Float
    let feelsLike: Float
    let humidity: Int
    let windSpeed: Float
    let rain: RainOneHourCodable?
    let weather: [WeatherCodable]

    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temperature = "temp"
        case feelsLike = "feels_like"
        case humidity = "humidity"
        case windSpeed = "wind_speed"
        case weather = "weather"
        case rain = "rain"
    }
}

struct RainOneHourCodable: Codable {
    let value: Float

    enum CodingKeys: String, CodingKey {
        case value = "1h"
    }
}

extension MissingForecastHourCodable {
    func convertToForecastHourCodable() -> ForecastHourCodable {
        return ForecastHourCodable(
            dt: self.date,
            main: MainDetailsCodable(
                temp: self.temperature,
                feelsLike: self.feelsLike,
                humidity: self.humidity
            ),
            weather: self.weather,
            wind: WindCodable(speed: self.windSpeed),
            rain: RainCodable(the3H: self.rain?.value ?? 0)
        )
    }
}

extension ForecastCodable {
    func convertToForecast() -> Forecast {
        
        var days: [ForecastDay] = []
        
        var hoursList: [ForecastHourCodable] = []
        if let missingHours = self.missing {
            for i in stride(from: 0, to: missingHours.count, by: 3) {
                hoursList.append(missingHours[i].convertToForecastHourCodable())
            }
        }
        hoursList += self.list
        for dayItem in groupForecastByDays(hoursList) {
            
            var hours: [ForecastHour] = []
            for hourItem in dayItem {
                hours.append(createHour(hourItem))
            }
            days.append(createDay(dayItem, hours: hours))
        }
        if days.count > 5 { days.removeLast() }
        
        return Forecast(cityName: self.city.name, forecast: days)
    }
}
