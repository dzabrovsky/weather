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

fileprivate func formatTemperature(_ dayItem: [ForecastHour]) -> String {
    return String( Int( dayItem.map( { Int($0.main.temp) } ).reduce(0, +) / dayItem.count ) ) + "°"
}

fileprivate func formatTemperatureFeelsLike(_ dayItem: [ForecastHour]) -> String {
    return String( Int( dayItem.map( { Int($0.main.feelsLike) } ).reduce(0, +) / dayItem.count ) ) + "°"
}

fileprivate func formatWind(_ dayItem: [ForecastHour]) -> String {
    let value = dayItem.map( { Float($0.wind.speed) } ).reduce(0, +) / Float(dayItem.count)
    return String(format: "%.1fм/с", value )
}

fileprivate func formatHumidity(_ dayItem: [ForecastHour]) -> String {
    return String( Int( dayItem.map( { $0.main.humidity } ).reduce(0, +) / dayItem.count ) ) + "%"
}

fileprivate func formatPrecipitation(_ dayItem: [ForecastHour]) -> String{
    let value = dayItem.map( { Float($0.rain?.the3H ?? 0) } ).reduce(0, +) / Float(dayItem.count)
    return String(format: "%.2fмм", value )
}

fileprivate func getAverageImageSet(_ dayItem: [ForecastHour]) -> [UIImage] {
    return ImageManager.getIconAnimateByCode(
        Dictionary( grouping: dayItem, by: { $0.weather[0].icon })
            .sorted( by: { $0.value.count > $1.value.count } )
            .first?.value[0].weather[0].icon ?? "" )
}

fileprivate func getDescription(_ dayItem: [ForecastHour]) -> String{
    return Dictionary(
        grouping: dayItem,
        by: { $0.weather[0].weatherDescription })
        .sorted(by: { $0.value.count > $1.value.count })
        .first?.value[0].weather[0].weatherDescription ?? ""
}

fileprivate func createHour(_ hourItem: ForecastHour) -> ForecastHourDataSource {
    return ForecastHourDataSource(
        temperature: String( Int( hourItem.main.temp ) ) + "°",
        tempValue: Double(hourItem.main.temp),
        feelsLike: String( Int( hourItem.main.feelsLike ) ) + "°",
        icon: ImageManager.getIconByCode( hourItem.weather[0].icon ),
        hour: String( returnHour(hourItem.dt) ) + ":00"
    )
}

fileprivate func createDay(_ dayItem: [ForecastHour], hours: [ForecastHourDataSource]) -> ForecastDayDataSource{
    return ForecastDayDataSource(
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

fileprivate func groupForecastByDays(_ forecast: Forecast) -> [[ForecastHour]] {
    return Array(Dictionary(grouping: forecast.list, by: { dropTime($0.dt) } ).values)
        .sorted(by: { $0[0].dt < $1[0].dt } )
}

struct Forecast: Codable {
    let list: [ForecastHour]
    let city: City
}

struct City: Codable {
    let name: String
    let coord: Coord
    let country: String
    let population: Int
}

struct Coord: Codable {
    let lat, lon: Double
}

struct ForecastHour: Codable {
    let dt: Int
    let main: MainDetails
    let weather: [Weather]
    let wind: Wind
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, wind
        case rain = "rain"
    }
}

struct MainDetails: Codable {
    let temp, feelsLike: Float
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case humidity
    }
}

struct Rain: Codable {
    let the3H: Float

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

struct Weather: Codable {
    let weatherDescription: String!
    let icon: String

    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon = "icon"
    }
}

struct Wind: Codable {
    let speed: Double
}
extension Forecast {
    func convertToForecast() -> ForecastDataSource {
        
        var days: [ForecastDayDataSource] = []
        for dayItem in groupForecastByDays(self) {
            var hours: [ForecastHourDataSource] = []
            for hourItem in dayItem {
                hours.append(createHour(hourItem))
            }
            days.append(createDay(dayItem, hours: hours))
        }
        if days.count > 5 { days.removeLast() }
        
        return ForecastDataSource(cityName: self.city.name, forecast: days)
    }
}
