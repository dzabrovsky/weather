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
    
    func updateWeatherInCity(_ city: Cities, completion: @escaping (CityListItem) -> Void, error: @escaping (AlamofireStatus) -> Void) {
        alamofireFacade.getCurrentWeather(lat: city.lat, lon: city.lon, completion: completion, error: error)
    }
}

extension SearchModel: SearchModelProtocol {
    
    func updateCityList(completion: @escaping (CityListItem, Int) -> Void, error: @escaping (AlamofireStatus) -> Void){
        guard var cities = coreDataFacade.getCities() else { return }
        cities.sort(by: { $0.index < $1.index })
        for item in cities {
            print(item.index)
            updateWeatherInCity(
                item,
                completion: { result in
                    var city = result
                    city.index = item.index
                    completion(city, cities.count)
                },
                error: error
            )
        }
    }
    
    func insertCity(_ name: String, completion: @escaping (CityListItem?, CheckResult) -> Void, error: @escaping (AlamofireStatus) -> Void) {
        
        coreDataFacade.checkCityNameExists(name) { check in
            guard !check else{
                completion(nil, .AlreadyExists)
                return
            }
            self.alamofireFacade.searchCity(
                name,
                completion: { result in
                    guard result.geonames.count > 0 else{
                        completion(nil, .NotExists)
                        return
                    }
                    guard result.geonames.contains(where: { $0.name == name || $0.toponymName == name}) else{
                        completion(nil, .NotExists)
                        return
                    }
                    self.alamofireFacade.getCurrentWeather(
                        name,
                        completion: { data in
                            self.coreDataFacade.checkCityNameExists(data.name) { check in
                                guard !check else{
                                    completion(nil, .AlreadyExists)
                                    return
                                }
                                self.coreDataFacade.insertCity(data.name, lat: data.lat, lon: data.lon){
                                    completion(data, .Succed)
                                }
                            }
                        },
                        error: error
                    )
                },
                error: error
            )
        }
    }
    
    func getCityData(_ name: String, completion: @escaping (String, Double, Double) -> (), error: @escaping (AlamofireStatus) -> Void) {
        coreDataFacade.getCityCoordinates(name) { _, lat, lon in
            completion(name, lat, lon)
        }
    }
    
    func searchCity(_ byName: String, completion: @escaping (SearchGeoNames) -> (), error: @escaping (AlamofireStatus) -> ()) {
        alamofireFacade.searchCityBySymbols(byName, completion: completion, error: error)
    }
    
    func deleteCity(_ index: Int, completion: @escaping () -> ()) {
        coreDataFacade.deleteCityFromList(index) {
            completion()
        }
    }
    
    func swapCitiesInList(at source: Int, to destination: Int) {
        coreDataFacade.swapCitiesInList(at: source, to: destination)
    }
}
