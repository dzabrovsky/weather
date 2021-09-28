import UIKit
import CoreData

protocol CoreDataFacadeProtocol {
    func checkCityNameExists(_ name: String, completion: @escaping (Bool) -> ())
    func insertCity(_ name: String, lat: Double, lon: Double)
    func getCityDetails(_ name: String, completion: @escaping (String, Double, Double) -> ())
    func getCities() -> [Cities]?
}

class CoreDataFacade {
    
    static let shared: CoreDataFacadeProtocol = CoreDataFacade()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init(){
        
    }
    
}

extension CoreDataFacade: CoreDataFacadeProtocol {
    
    func getCities() -> [Cities]? {
        do{
            guard let cities = (try context.fetch(Cities.fetchRequest())) as? [Cities] else { return nil }
            return cities
        }catch{
            return nil
        }
    }
    
    func getCityDetails(_ name: String, completion: @escaping (String, Double, Double) -> ()) {
        do{
            guard let cities = (try context.fetch(Cities.fetchRequest())) as? [Cities] else { return }
            guard let city = cities.first(where: { $0.name == name }) else{ return }
            completion(city.name, city.lat, city.lon)
        }catch{
            //error
        }
    }
    
    func insertCity(_ name: String, lat: Double, lon: Double) {
        let city = Cities(context: context)
        city.name = name
        city.lat = lat
        city.lon = lon
        city.lastUse = Date()
        
        do {
            try context.save()
        }catch{
            // error
        }
    }
    
    func checkCityNameExists(_ name: String, completion: @escaping (Bool) -> ()) {
        do{
            guard let cities = (try context.fetch(Cities.fetchRequest())) as? [Cities] else{ return }
            completion(cities.first(where: { $0.name == name }) != nil)
        }catch{
            //error
        }
    }
}
