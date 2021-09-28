import Foundation
import CoreLocation
import Alamofire

class MapModel {
    
    private let locationManagerFacade = LocationManagerFacade()
    private let alamofireFacade = AlamofireFacade.shared
    
    func updateWeatherDataInCity(_ cityName: String) {
        
    }
    
    func updateGeonames(east: Double, west: Double, north: Double, south: Double, completion: @escaping (CityListItem) -> Void){
        
        alamofireFacade.getCities(east: east, west: west, north: north, south: south){ result in
            self.updateCurrentDataInGeonames(result){ result in
                completion(result)
            }
        }
    }
    
    func updateCurrentDataInGeonames(_ geonames: Geonames, completion: @escaping (CityListItem) -> Void) {
        
        for geoname in geonames.geonames {
            if let name = geoname.name {
                alamofireFacade.getCurrentWeather(name){ result in
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
