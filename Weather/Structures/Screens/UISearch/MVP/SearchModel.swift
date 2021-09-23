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
    case Complete
}

class SearchModel: Model{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func updateWeatherInCity(_ name: String, completion: @escaping (CityListItem) -> Void) {
        
        guard let url = URL(string: ("https://api.openweathermap.org/data/2.5/weather?q=\(name)&appid=\(APIKey)&lang=\(lang)&units=\(units)").encodeUrl) else {
            print("Cannot covert string to URL")
            return
        }
        getCurrentDataFromAPI(url){ result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func updateCityList(completion: @escaping (CityListItem) -> Void){
        do {
            if var cities = (try context.fetch(Cities.fetchRequest())) as? [Cities] {
                cities.sort(by: { $0.lastUse! > $1.lastUse! })
                for item in cities {
                    print(item.lastUse!)
                    if let name = item.name {
                        updateWeatherInCity(name) { result in
                            completion(result)
                        }
                    }
                }
            }
        }catch{
            // error
        }
    }
    
    func checkCity(_ name: String, completion: @escaping (CityListItem?, CheckResult) -> Void) {
        do {
            if let cities = (try context.fetch(Cities.fetchRequest())) as? [Cities] {
                if let _ = cities.first(where: { $0.name == name } ) {
                    completion(nil, .AlreadyExists)
                }else{
                    guard let url = URL(string: ("http://api.geonames.org/searchJSON?q=\(name)&username=ivan&style=MEDIUM&lang=ru").encodeUrl) else {
                        print("Cannot covert string to URL")
                        return
                    }
                    
                    searchCity(url) { (result) in
                        DispatchQueue.main.async {
                            if result.geonames.count > 0 {
                                if result.geonames.contains(where: { $0.name == name}) {
                                    self.insertCityInCitiesList(name: name) { result in
                                        completion(result, .Complete)
                                    }
                                }
                            }else{
                                completion(nil, .NotExists)
                            }
                        }
                    }
                }
            }
        }catch{
            
        }
    }
    
    func insertCityInCitiesList(name: String, completion: @escaping (CityListItem) -> Void){
        let city = Cities(context: context)
        guard let url = URL(string: ("https://api.openweathermap.org/data/2.5/weather?q=\(name)&appid=\(APIKey)&lang=\(lang)").encodeUrl) else{
            print("Cannot covert string to URL")
            return
        }
        getCurrentDataFromAPI(url){ result in
            DispatchQueue.main.async {
                city.name = result.name
                print(result.name)
                city.lat = result.lat
                city.lon = result.lon
            }
        }
        
        city.lastUse = Date()
        do {
            DispatchQueue.main.async {
                self.updateWeatherInCity(name){ result in
                    completion(result)
                }
            }
            try context.save()
        }catch{
            // error
        }
    }
    
    func updateCityLastUse(_ name: String, completion: @escaping (String, Double, Double) -> Void){
        do {
            if let cities = (try context.fetch(Cities.fetchRequest())) as? [Cities] {
                if let city = cities.filter({ $0.name == name }).first {
                    city.lastUse = Date()
                    try context.save()
                    DispatchQueue.main.async {
                        completion(city.name ?? "", city.lat, city.lon)
                    }
                }
            }
        }catch{
            // error
        }
    }
    
}
