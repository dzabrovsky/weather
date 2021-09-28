import Foundation
import Alamofire

class AlamofireFacade {
    
    func getForecast(lat: Double, lon: Double, completion: @escaping (Forecast) -> ()) {
        
        let lang = UserDataRepository.shared.getLang()
        let APIKey = UserDataRepository.shared.getAPIKey()
        let units = UserDataRepository.shared.getUnits()
        
        let APIUrl = "https://api.openweathermap.org/data/2.5/forecast"
        
        guard let url = URL(string: ("\(APIUrl)?lat=\(lat)&lon=\(lon)&appid=\(APIKey)&lang=\(lang)&units=\(units)").encodeUrl)
        else { return }
        
        AF.request(url)
            .validate()
            .responseDecodable(of: Forecast.self) { (response) in
                if let data = response.value {
                    completion(data)
                }
            }
    }
    
    func getForecast(_ cityName: String, completion: @escaping (Forecast) -> ()) {
        
        let lang = UserDataRepository.shared.getLang()
        let APIKey = UserDataRepository.shared.getAPIKey()
        let units = UserDataRepository.shared.getUnits()
        
        let APIUrl = "https://api.openweathermap.org/data/2.5/forecast"
        
        guard let url = URL(string: ("\(APIUrl)?q=\(cityName)&appid=\(APIKey)&lang=\(lang)&units=\(units)").encodeUrl)
        else { return }
        
        AF.request(url)
            .validate()
            .responseDecodable(of: Forecast.self) { (response) in
                if let data = response.value {
                    completion(data)
                }
            }
    }
    
    func getCurrentWeather(_ cityName: String, completion: @escaping (CityListItem) -> ()) {
        
        let lang = UserDataRepository.shared.getLang()
        let APIKey = UserDataRepository.shared.getAPIKey()
        let units = UserDataRepository.shared.getUnits()
        
        let APIUrl = "https://api.openweathermap.org/data/2.5/weather"
        
        guard let url = URL(string: ("\(APIUrl)?q=\(cityName)&appid=\(APIKey)&lang=\(lang)&units=\(units)").encodeUrl)
        else { return }
        var result = CityListItem()
        
        AF.request(url)
            .validate()
            .responseDecodable(of: Current.self) { (response) in
                switch response.result {
                case .success(let data):
                    
                    result.lat = data.coord.lat
                    result.lon = data.coord.lon
                    result.name = data.name
                    result.temp = data.main.temp
                    result.tempFeelsLike = data.main.feelsLike
                    result.icon = data.weather[0].icon
                    
                    completion(result)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func searchCity(_ cityName: String, completion: @escaping (SearchGeoNames) -> ()){
        
        let lang = UserDataRepository.shared.getLang()
        let APIUrl = "https://api.openweathermap.org/data/2.5/weather"
        
        guard let url = URL(string: ("\(APIUrl)q=\(cityName)&username=ivan&style=MEDIUM&lang=\(lang)").encodeUrl)
        else { return }
        AF.request(url).validate().responseDecodable(of: SearchGeoNames.self) { (response) in
            if let data = response.value {
                completion(data)
            }
        }
    }
    
}
