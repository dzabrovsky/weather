import UIKit

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
