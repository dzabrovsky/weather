import Foundation
import Alamofire

protocol AlamofireFacadeProtocol {
    func getCities(east: Double, west: Double, north: Double, south: Double, completion: @escaping (GeonamesCodable) -> Void)
    func getForecast(lat: Double, lon: Double, completion: @escaping (ForecastCodable) -> ())
    func getCurrentWeather(_ cityName: String, completion: @escaping (CityListItem) -> ())
    func getCurrentWeather(lat: Double, lon: Double, completion: @escaping (CityListItem) -> ())
    func searchCity(_ cityName: String, completion: @escaping (SearchGeoNames) -> ())
    func searchCityBySymbols(_ symbols: String, completion: @escaping (SearchGeoNames) -> ())
}

class AlamofireFacade {
    
    static let shared: AlamofireFacadeProtocol = AlamofireFacade()
    
    private init(){
        
    }
    
    private func dropTime(_ dateTime: Int) -> Int {
        return dateTime / 86400 * 86400
    }
    
    private func getTodayMissingHours(lat: Double, lon: Double, completion: @escaping (MissingForecastCodable) -> ()) {
        
        let lang = UserDataRepository.shared.getLang()
        let APIKey = UserDataRepository.shared.getAPIKey()
        let units = UserDataRepository.shared.getUnits()
        let time = dropTime(Int(Date().timeIntervalSince1970))
        
        let APIUrl = "http://api.openweathermap.org/data/2.5/onecall/timemachine?"
        
        guard let url = URL(string: ("\(APIUrl)lat=\(lat)&lon=\(lon)&dt=\(time)&units=\(units)&lang=\(lang)&appid=\(APIKey)").encodeUrl)
        else { return }
        
        AF.request(url)
            .validate()
            .responseDecodable(of: MissingForecastCodable.self) { (response) in
                if let data = response.value {
                    completion(data)
                }
            }
    }
}

extension AlamofireFacade: AlamofireFacadeProtocol {
    func getCities(east: Double, west: Double, north: Double, south: Double, completion: @escaping (GeonamesCodable) -> Void){
        
        guard let url = URL(string: ("http://api.geonames.org/citiesJSON?username=ivan&south=\(south)&north=\(north)&west=\(west)&east=\(east)").encodeUrl) else {
            print("Cannot covert string to URL")
            return
        }
        
        AF.request(url)
            .validate()
            .responseDecodable(of: GeonamesCodable.self) { (response) in
                if let data = response.value {
                    completion(data)
                }
            }
    }
    
    func getForecast(lat: Double, lon: Double, completion: @escaping (ForecastCodable) -> ()) {
        
        let lang = UserDataRepository.shared.getLang()
        let APIKey = UserDataRepository.shared.getAPIKey()
        let units = UserDataRepository.shared.getUnits()
        
        let APIUrl = "https://api.openweathermap.org/data/2.5/forecast"
        
        guard let url = URL(string: ("\(APIUrl)?lat=\(lat)&lon=\(lon)&appid=\(APIKey)&lang=\(lang)&units=\(units)").encodeUrl)
        else { return }
        
        getTodayMissingHours(lat: lat, lon: lon) { result in
            AF.request(url)
                .validate()
                .responseDecodable(of: ForecastCodable.self) { (response) in
                    if var data = response.value {
                        data.missing = result.hourly
                        completion(data)
                    }
                }
        }
    }
    
    func getForecast(_ cityName: String, completion: @escaping (ForecastCodable) -> ()) {
        
        let lang = UserDataRepository.shared.getLang()
        let APIKey = UserDataRepository.shared.getAPIKey()
        let units = UserDataRepository.shared.getUnits()
        
        let APIUrl = "https://api.openweathermap.org/data/2.5/forecast"
        
        guard let url = URL(string: ("\(APIUrl)?q=\(cityName)&appid=\(APIKey)&lang=\(lang)&units=\(units)").encodeUrl)
        else { return }
        
        AF.request(url)
            .validate()
            .responseDecodable(of: ForecastCodable.self) { (response) in
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
    
    func getCurrentWeather(lat: Double, lon: Double, completion: @escaping (CityListItem) -> ()) {
        
        let lang = UserDataRepository.shared.getLang()
        let APIKey = UserDataRepository.shared.getAPIKey()
        let units = UserDataRepository.shared.getUnits()
        
        let APIUrl = "https://api.openweathermap.org/data/2.5/weather"
        
        guard let url = URL(string: ("\(APIUrl)?lat=\(lat)&lon=\(lon)&appid=\(APIKey)&lang=\(lang)&units=\(units)").encodeUrl)
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
        let APIUrl = "http://api.geonames.org/searchJSON?"
        
        guard let url = URL(string: ("\(APIUrl)q=\(cityName)&username=ivan&style=MEDIUM&lang=\(lang)").encodeUrl)
        else { return }
        print(url)
        AF.request(url).validate().responseDecodable(of: SearchGeoNames.self) { (response) in
            if let data = response.value {
                completion(data)
            } else {
                print(response.error ?? "")
            }
        }
    }
    
    func searchCityBySymbols(_ symbols: String, completion: @escaping (SearchGeoNames) -> ()){
        
        let lang = UserDataRepository.shared.getLang()
        let APIUrl = "http://api.geonames.org/searchJSON?"
        
        guard let url = URL(string: ("\(APIUrl)name_startsWith=\(symbols)&username=ivan&style=MEDIUM&lang=\(lang)").encodeUrl)
        else { return }
        AF.request(url).validate().responseDecodable(of: SearchGeoNames.self) { (response) in
            if let data = response.value {
                completion(data)
            } else {
                print(response.error ?? "")
            }
        }
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
