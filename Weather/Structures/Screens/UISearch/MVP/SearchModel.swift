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
    
    private let alamofireFacade = AlamofireFacade.shared
    private let coreDataFacade = CoreDataFacade.shared
    
    func updateWeatherInCity(_ name: String, completion: @escaping (CityListItem) -> Void) {
        alamofireFacade.getCurrentWeather(name){ result in
            completion(result)
        }
    }
    
    func updateCityList(completion: @escaping (CityListItem, Int) -> Void){
        guard var cities = coreDataFacade.getCities() else { return }
        cities.sort(by: { $0.index < $1.index })
        for item in cities {
            print(item.index)
            updateWeatherInCity(item.name) { result in
                var city = result
                city.index = item.index
                completion(city, cities.count)
            }
        }
    }
    
    func insertCity(_ name: String, completion: @escaping (CityListItem?, CheckResult) -> Void) {
        
        coreDataFacade.checkCityNameExists(name) { check in
            guard !check else{
                completion(nil, .AlreadyExists)
                return
            }
            self.alamofireFacade.searchCity(name) { result in
                guard result.geonames.count > 0 else{
                    completion(nil, .NotExists)
                    return
                }
                guard result.geonames.contains(where: { $0.name == name || $0.toponymName == name}) else{
                    completion(nil, .NotExists)
                    return
                }
                self.alamofireFacade.getCurrentWeather(name) { data in
                    self.coreDataFacade.checkCityNameExists(data.name) { check in
                        guard !check else{
                            completion(nil, .AlreadyExists)
                            return
                        }
                        self.coreDataFacade.insertCity(data.name, lat: data.lat, lon: data.lon){
                            completion(data, .Succed)
                        }
                    }
                }
            }
        }
    }
    
    func getCityData(_ name: String, completion: @escaping (String, Double, Double) -> () ) {
        coreDataFacade.getCityCoordinates(name) { _, lat, lon in
            completion(name, lat, lon)
        }
    }
    
    func searchCity(_ byName: String, completion: @escaping (SearchGeoNames) -> ()) {
        alamofireFacade.searchCityBySymbols(byName) { result in
            completion(result)
        }
    }
    
    func deleteCity(_ index: Int, completion: @escaping () -> ()) {
        coreDataFacade.deleteCityFromList(index) {
            completion()
        }
    }
    
    func swapCitiesInList(source: Int, destination: Int) {
        coreDataFacade.swapCitiesInList(source: source, destination: destination)
    }
}
