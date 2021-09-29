import UIKit

struct Forecast {
    let cityName: String
    let forecast: [ForecastDayDataSource]
}

struct ForecastDayDataSource {
    let temperature: String
    let feelsLike: String
    let icon: [UIImage]
    let date: String
    let description: String
    let forecast: [ForecastHourDataSource]
    let wind: String
    let humidity: String
    let precipitation: String
}

struct ForecastHourDataSource {
    let temperature: String
    let tempValue: Double
    let feelsLike: String
    let icon: UIImage
    let hour: String
}
