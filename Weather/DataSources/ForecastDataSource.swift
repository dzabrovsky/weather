import UIKit

struct ForecastDataSource {
    let cityName: String
    let forecast: [ForecastDayDataSource]
}

struct ForecastDayDataSource {
    let temp: String
    let feelsLike: String
    let icon: UIImage
    let date: String
    let description: String
    let forecast: [ForecastHourDataSource]
}

struct ForecastHourDataSource {
    let temp: String
    let feelsLike: String
    let icon: UIImage
    let hour: String
}
