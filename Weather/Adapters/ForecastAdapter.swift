import UIKit

class ForecastAdapter {
    
    static func convertToForecast(from: Forecast) -> ForecastDataSource {
        
        let forecastByDays = Array(Dictionary(grouping: from.list, by: { dropTime($0.dt) } ).values)
            .sorted(by: { $0[0].dt < $1[0].dt } )
        
        var days: [ForecastDayDataSource] = []
        for dayItem in forecastByDays {
            
            var hours: [ForecastHourDataSource] = []
            for hourItem in dayItem {
                
                let hour = ForecastHourDataSource(
                    temp: String( Int( hourItem.main.temp ) ) + "°",
                    feelsLike: String( Int( hourItem.main.feelsLike ) ) + "°",
                    icon: ImageManager.getIconByCode( hourItem.weather[0].icon ),
                    hour: String( returnHour(hourItem.dt) ) + ":00"
                )
                hours.append(hour)
            }
            
            let temp = String( Int( dayItem.map( { Int($0.main.temp) } ).reduce(0, +) / dayItem.count ) ) + "°"
            
            let feelsLike = String( Int( dayItem.map( { Int($0.main.feelsLike) } ).reduce(0, +) / dayItem.count ) ) + "°"
            
            let icon = ImageManager.getIconByCode(
                Dictionary( grouping: dayItem, by: { $0.weather[0].icon }).sorted( by: { $0.value.count > $1.value.count } ).first?.value[0].weather[0].icon ?? "" )
            
            let date: String = {
                let formatter = DateFormatter()
                formatter.dateFormat = "d MMMM, E"
                formatter.locale = Locale(identifier: "ru_RU")
                
                return formatter.string(
                    from: Date(
                        timeIntervalSince1970: TimeInterval(
                            dropTime( dayItem[0].dt )
                        )
                    )
                ).lowercased()
            }()
            
            let description = (Dictionary( grouping: dayItem,
                by: { $0.weather[0].weatherDescription }
            ).sorted( by: { $0.value.count > $1.value.count } ).first?.value[0].weather[0]
                .weatherDescription ?? "") + ", ощущается как " + feelsLike
            
            let day = ForecastDayDataSource(
                temp: temp,
                feelsLike: feelsLike,
                icon: icon,
                date: date,
                description: description,
                forecast: hours
            )
            days.append(day)
        }
        
        return ForecastDataSource(cityName: from.city.name, forecast: days)
    }
    
    static func dropTime(_ dt: Int) -> Int{
        return dt - dt % Int(86400)
    }
    
    static func returnHour(_ dt: Int) -> Int{
        return ( dt % Int(86400) ) / 3600
    }
}
