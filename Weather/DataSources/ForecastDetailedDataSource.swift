import UIKit

struct ForecastDetailedDayDataSource {
    let temp: String
    let feelsLike: String
    let icon: UIImage
    let date: String
    let description: String
    let forecast: [ForecastHourDataSource]
    let wind: String
    let humidity: String
    let precipitation: String
}
