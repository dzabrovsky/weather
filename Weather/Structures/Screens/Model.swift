import Foundation
import Alamofire

class Model: NSObject {
    
    func getCurrentDataFromAPI(_ url:URL, completion: @escaping (CityListItem) -> Void) {

        print("---===",url,"===---")
        var result = CityListItem()
        
        AF.request(url)
            .validate()
            .responseDecodable(of: Current.self) { (response) in
                if let data = response.value {
                    
                    result.lat = data.coord.lat
                    result.lon = data.coord.lon
                    result.name = data.name
                    result.temp = data.main.temp
                    result.tempFeelsLike = data.main.feelsLike
                    result.icon = data.weather[0].icon
                    
                    completion(result)
                }
            }
        return
    }
    
    func getDataFromAPI (_ url:URL, completion: @escaping (WeatherData) -> Void) {
        
        print("---===",url,"===---")
        AF.request(url)
            .validate()
            .responseDecodable(of: Forecast.self) { (response) in
                if let data = response.value {
                    let list = Dictionary(grouping: data.list, by: { Model.dropTime($0.dt) })
                    let weatherData = WeatherData(cityName: data.city.name, coord: data.city.coord)
                    for day in list {
                        let weatherDay = WeatherDay(date: Date(timeIntervalSince1970: TimeInterval(Model.dropTime(day.value[0].dt))))
                        for item in day.value {
                            var hour = item
                            hour.hour = Model.returnHour(hour.dt)
                            weatherDay.forecast.append(hour)
                        }
                        weatherDay.icon = Dictionary(grouping: weatherDay.forecast, by: { $0.weather[0].icon }).sorted(by: { $0.value.count > $1.value.count }).first?.value[0].weather[0].icon ?? ""
                        weatherDay.temp = Int( weatherDay.forecast.map( { Int($0.main.temp) } ).reduce(0, +) / weatherDay.forecast.count )
                        weatherDay.feelsLike = Int( weatherDay.forecast.map( { Int($0.main.feelsLike) } ).reduce(0, +) / weatherDay.forecast.count )
                        weatherData.data.append(weatherDay)
                    }
                    weatherData.data.sort(by: { $0.date < $1.date })
                    completion(weatherData)
                }
            }
    }
    
    static func dropTime(_ dt: Int) -> Int{
        return dt - dt % Int(86400)
    }
    
    static func returnHour(_ dt: Int) -> Int{
        return ( dt % Int(86400) ) / 3600
    }
}
