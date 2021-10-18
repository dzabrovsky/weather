import Foundation
import CoreLocation
import Alamofire

enum CheckCityStatus {
    case alamofireError
}

class MapModel {
    
    private let locationManagerFacade = LocationManagerFacade.shared
    private let alamofireFacade = AlamofireFacade.shared
    private let coreDataFacade = CoreDataFacade.shared
    
    func updateGeonames(east: Double, west: Double, north: Double, south: Double, completion: @escaping (CityListItem) -> Void, error: @escaping (AlamofireStatus) -> Void){
        
        alamofireFacade.getCities(
            s: south,
            n: north,
            w: west,
            e: east,
            completion:{ result in
                self.updateCurrentDataInGeonames(result, completion: completion, error: error)
            },
            error: error
        )
    }
    
    func updateCurrentDataInGeonames(_ geonames: GeonamesCodable, completion: @escaping (CityListItem) -> Void, error: @escaping (AlamofireStatus) -> Void) {
        
        for geoname in geonames.geonames {
            if let lat = geoname.lat, let lon = geoname.lon {
                alamofireFacade.getCurrentWeather(lat: lat, lon: lon, completion: completion, error: error)
            }
        }
    }
    
    func updateLocation(completion: @escaping (Coordindates) -> ()) {
        
        locationManagerFacade.getCurrentLocation{ result in
            completion(result)
        }
    }
    
    func insertCity(lat: Double, lon: Double, completion: @escaping (CityListItem?, CheckResult) -> Void, error: @escaping (AlamofireStatus) -> Void) {
        
        alamofireFacade.getCurrentWeather(
            lat: lat,
            lon: lon,
            completion: { data in
                self.coreDataFacade.checkCityNameExists(data.name) { check in
                    guard !check else{
                        completion(data, .AlreadyExists)
                        return
                    }
                    self.coreDataFacade.insertCity(data.name, lat: data.lat, lon: data.lon){
                        completion(data, .Succed)
                    }
                }
            },
            error: error
        )
    }
}
