import UIKit

struct Forecast: Codable {
    let cod: String
    let message, cnt: Int
    let list: [WeatherHour]
    let city: City
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

struct Coord: Codable {
    let lat, lon: Double
}

struct WeatherHour: Codable {
    let dt: Int
    var hour: Int = 0
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, wind
        case rain = "rain"
    }
}

struct Main: Codable {
    let temp, feelsLike: Float
    let humidity: Int = 0

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
