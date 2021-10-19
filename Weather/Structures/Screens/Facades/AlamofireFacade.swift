import Foundation
import Alamofire

enum AlamofireStatus {
    case success
    case noNetwork
    case error
}

protocol AlamofireFacadeProtocol {
    func getCities(s south: Double, n north: Double, w west: Double, e east: Double, completion: @escaping (GeonamesCodable) -> Void, error: @escaping (AlamofireStatus) -> ())
    func getForecast(lat: Double, lon: Double, completion: @escaping (ForecastCodable) -> (), error: @escaping (AlamofireStatus) -> ())
    func getCurrentWeather(lat: Double, lon: Double, completion: @escaping (CityListItem) -> (), error: @escaping (AlamofireStatus) -> ())
    func getCurrentWeather(_ name: String, completion: @escaping (CityListItem) -> (), error: @escaping (AlamofireStatus) -> ())
    func searchCity(_ cityName: String, completion: @escaping (SearchGeoNames) -> (), error: @escaping (AlamofireStatus) -> ())
    func searchCityBySymbols(_ symbols: String, completion: @escaping (SearchGeoNames) -> (), error: @escaping (AlamofireStatus) -> ())
}

class AlamofireFacade {
    
    static let shared: AlamofireFacadeProtocol = AlamofireFacade()
    
    typealias Parameters = [String:String]
    
    private init(){
        
    }
    
    private func dropTime(_ dateTime: Int) -> Int {
        return dateTime / 86400 * 86400
    }
    
    private func timemachineParameters(lat: Double, lon: Double) -> Parameters{
        let time = dropTime(Int(Date().timeIntervalSince1970))
        return [
            "lat":String(lat),
            "lon":String(lon),
            "dt":String(time),
            "units":unitsConstant,
            "lang":langConstant,
            "appid":APIKeyConstant
        ]
    }
    
    private func citiesJSONURLParameters(s south: Double, n north: Double, w west: Double, e east: Double) -> Parameters {
        return [
            "username":APIUserNameConstant,
            "south":String(south),
            "north":String(north),
            "west":String(west),
            "east":String(east)
        ]
    }
    
    private func searchCityParameters(_ cityName: String) -> Parameters {
        return [
            "q":cityName,
            "username":APIUserNameConstant,
            "style":"MEDIUM",
            "lang":langConstant
        ]
    }
    
    private func searchCityBySymbols(_ startsWith: String) -> Parameters {
        return [
            "name_startsWith":startsWith,
            "username":APIUserNameConstant,
            "style":"MEDIUM",
            "lang":langConstant
        ]
    }
    
    private func weatherParameters(lat: Double, lon: Double) -> Parameters {
        return [
            "lat":String(lat),
            "lon":String(lon),
            "units":unitsConstant,
            "lang":langConstant,
            "appid":APIKeyConstant
        ]
    }
    
    private func weatherCityNameParameters(_ cityName: String) -> Parameters {
        return [
            "q":cityName,
            "units":unitsConstant,
            "lang":langConstant,
            "appid":APIKeyConstant
        ]
    }
    
    private func getResponse<T: Decodable>(
        of type: T.Type = T.self,
        url: String,
        parameters: Parameters,
        completion: @escaping (T) -> (),
        error: @escaping (AlamofireStatus) -> ()
    ){
        let af = AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: type.self){ response in
                guard let data = response.value else {
                    error(.error)
                    return
                }
                completion(data)
            }
        guard af.error != nil else { return }
        error(.error)
    }
    
    private func getTodayMissingHours(lat: Double, lon: Double, completion: @escaping (MissingForecastCodable) -> (), error: @escaping (AlamofireStatus) -> ()) {
        
        getResponse(
            of: MissingForecastCodable.self,
            url: timemachineURL,
            parameters: timemachineParameters(lat: lat, lon: lon),
            completion: completion,
            error: error
        )
    }
}

extension AlamofireFacade: AlamofireFacadeProtocol {
    func getCities(s south: Double, n north: Double, w west: Double, e east: Double, completion: @escaping (GeonamesCodable) -> Void, error: @escaping (AlamofireStatus) -> ()){
        
        getResponse(
            of: GeonamesCodable.self, url: citiesJSONURL,
            parameters: citiesJSONURLParameters(s: south, n: north, w: west, e: east),
            completion: completion,
            error: error
        )
    }
    
    func getForecast(lat: Double, lon: Double, completion: @escaping (ForecastCodable) -> (), error: @escaping (AlamofireStatus) -> ()) {
        
        getResponse(
            of: ForecastCodable.self, url: forecastURL,
            parameters: weatherParameters(lat: lat, lon: lon),
            completion: completion,
            error: error
        )
    }
    
    func getCurrentWeather(_ cityName: String, completion: @escaping (CityListItem) -> (), error: @escaping (AlamofireStatus) -> ()) {
        
        var data = CityListItem()
        
        getResponse(
            of: Current.self, url: currentWeatherURL,
            parameters: weatherCityNameParameters(cityName),
            completion: { result in
                
                data.lat = result.coord.lat
                data.lon = result.coord.lon
                data.name = result.name
                data.temp = result.main.temp
                data.tempFeelsLike = result.main.feelsLike
                data.icon = result.weather[0].icon
                
                completion(data)
            },
            error: error
        )
    }
    
    func getCurrentWeather(lat: Double, lon: Double, completion: @escaping (CityListItem) -> (), error: @escaping (AlamofireStatus) -> ()) {
        
        var data = CityListItem()
        
        getResponse(
            of: Current.self, url: currentWeatherURL,
            parameters: weatherParameters(lat: lat, lon: lon),
            completion: { result in
                
                data.lat = result.coord.lat
                data.lon = result.coord.lon
                data.name = result.name
                data.temp = result.main.temp
                data.tempFeelsLike = result.main.feelsLike
                data.icon = result.weather[0].icon
                
                completion(data)
            },
            error: error
        )
    }
    
    func searchCity(_ cityName: String, completion: @escaping (SearchGeoNames) -> (), error: @escaping (AlamofireStatus) -> ()){
        
        getResponse(
            of: SearchGeoNames.self, url: searchJSONURL,
            parameters: searchCityParameters(cityName),
            completion: completion,
            error: error
        )
    }
    
    func searchCityBySymbols(_ symbols: String, completion: @escaping (SearchGeoNames) -> (), error: @escaping (AlamofireStatus) -> ()){
        
        getResponse(
            of: SearchGeoNames.self, url: searchJSONURL,
            parameters: searchCityBySymbols(symbols),
            completion: completion,
            error: error
        )
    }
    
}
