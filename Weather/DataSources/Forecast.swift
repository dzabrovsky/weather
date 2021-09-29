import UIKit

struct Forecast {
    let cityName: String
    let forecast: [ForecastDay]
}

struct ForecastDay {
    let temperature: String
    let feelsLike: String
    let icon: [UIImage]
    let date: String
    let description: String
    let forecast: [ForecastHour]
    let wind: String
    let humidity: String
    let precipitation: String
}

struct ForecastHour {
    let temperature: String
    let tempValue: Double
    let feelsLike: String
    let icon: UIImage
    let hour: String
    let hourValue: Int
}
