import UIKit
import CoreData

protocol SearchPresenterProtocolForModel: AnyObject {
    func didCityLastUseUpdate(lat: Double, lon: Double)
    func cityListUpdated(_ dataSource: CityListItem)
    func cityAlreadyExists()
    func cityDoesNotExists()
}

enum CheckResult {
    case AlreadyExists
    case NotExists
    case Succed
}

class SearchModel{
    
    private let alamofireFacade = AlamofireFacade()
    
    func updateWeatherInCity(_ name: String, completion: @escaping (CityListItem) -> Void) {
        alamofireFacade.getCurrentWeather(name){ result in
            completion(result)
        }
    }
    
    func updateCityList(completion: @escaping (CityListItem) -> Void){
        guard var cities = CoreDataFacade.shared.getCities() else{ return }
        cities.sort(by: { $0.lastUse! > $1.lastUse! })
        for item in cities {
            print(item.lastUse!)
            updateWeatherInCity(item.name) { result in
                completion(result)
            }
        }
    }
    
    func insertCity(_ name: String, completion: @escaping (CityListItem?, CheckResult) -> Void) {
        
        CoreDataFacade.shared.checkCityNameExists(name) { check in
            guard !check else{
                completion(nil, .AlreadyExists)
                return
            }
            self.alamofireFacade.searchCity(name) { result in
                guard result.geonames.count == 0 else{
                    completion(nil, .NotExists)
                    return
                }
                guard !result.geonames.contains(where: { $0.name == name}) else{
                    completion(nil, .NotExists)
                    return
                }
                self.alamofireFacade.getCurrentWeather(name) { data in
                    CoreDataFacade.shared.insertCity(data.name, lat: data.lat, lon: data.lon)
                }
            }
        }
    }
    
    func getCityData(_ name: String, completion: @escaping (String, Double, Double) -> () ) {
        CoreDataFacade.shared.getCityDetails(name) { name, lat, lon in
            completion(name, lat, lon)
        }
    }
    
}
