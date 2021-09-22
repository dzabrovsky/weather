import Foundation
import Alamofire

class Model: NSObject {
    
    let lang: String = "ru"
    let units: String = "metric"
    let defaultCityName: String = "Moscow"
    var cityName:String = "Tambov"
    let APIKey:String = "830e252225a6214c4370ecfee9b1d912"
    
    func getCurrentDataFromAPI(_ url: URL, completion: @escaping (CityListItem) -> Void) {
        
        print("Log: request to \(url)\"")
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
    
    func searchCity(_ url: URL, completion: @escaping (SearchGeoNames) -> Void) {
        
        print("Log: request to \(url)")
        AF.request(url).validate().responseDecodable(of: SearchGeoNames.self) { (response) in
            if let data = response.value {
                completion(data)
            }
        }
        return
    }
    
    func getDataFromAPI (_ url: URL, completion: @escaping (Forecast) -> Void) {
        
        print("Log: request to \(url)\"")
        AF.request(url)
            .validate()
            .responseDecodable(of: Forecast.self) { (response) in
                if let data = response.value {
                    completion(data)
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

extension String{
    var encodeUrl : String
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String
    {
        return self.removingPercentEncoding!
    }
}
