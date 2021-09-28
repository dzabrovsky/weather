import Foundation
import CoreLocation
import Alamofire

class MapModel {
    
    private let locationManagerFacade = LocationManagerFacade.shared
    private let alamofireFacade = AlamofireFacade.shared
    private let coreDataFacade = CoreDataFacade.shared
    
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
    
    func insertCity(lat: Double, lon: Double, completion: @escaping (CityListItem?, CheckResult) -> Void) {
        
        alamofireFacade.getCurrentWeather(lat: lat, lon: lon) { data in
            
            self.coreDataFacade.checkCityNameExists(data.name) { check in
                guard !check else{
                    completion(data, .AlreadyExists)
                    return
                }
                self.coreDataFacade.insertCity(data.name, lat: data.lat, lon: data.lon){
                    completion(data, .Succed)
                }
            }
        }
    }
}
