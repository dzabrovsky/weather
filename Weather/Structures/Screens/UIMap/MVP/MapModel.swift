import Foundation
import CoreLocation
import Alamofire

class MapModel: Model {
    
    private let locationManagerFacade = LocationManagerFacade()
    
    func updateWeatherDataInCity(_ cityName: String) {
        
    }
    
    func updateGeonames(east: Double, west: Double, north: Double, south: Double, completion: @escaping (CityListItem) -> Void){
        
        guard let url = URL(string: ("http://api.geonames.org/citiesJSON?username=ivan&south=\(south)&north=\(north)&west=\(west)&east=\(east)").encodeUrl) else {
            print("Cannot covert string to URL")
            return
        }
        
        AF.request(url)
            .validate()
            .responseDecodable(of: Geonames.self) { (response) in
                if let data = response.value {
                    self.updateCurrentDataInGeonames(data, completion: completion)
                }
            }
    }
    
    func updateCurrentDataInGeonames(_ geonames: Geonames, completion: @escaping (CityListItem) -> Void) {
        
        for geoname in geonames.geonames {
            guard let url = URL(string: ("https://api.openweathermap.org/data/2.5/weather?lat=\(geoname.lat!)&lon=\(geoname.lon!)&appid=\(APIKey)&lang=\(lang)&units=\(units)").encodeUrl) else {
                print("Cannot covert string to URL")
                return
            }
            
            getCurrentDataFromAPI(url){ result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    func updateLocation(completion: @escaping (Coord) -> ()) {
        
        locationManagerFacade.getCurrentLocation{ result in
            completion(result)
        }
    }
    
    func getCityNameByCoord(lat: Double, lon: Double, completion: @escaping (String) -> Void) {
        
    }
}
