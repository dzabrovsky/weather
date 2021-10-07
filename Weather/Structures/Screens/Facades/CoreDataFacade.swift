import UIKit
import CoreData

protocol CoreDataFacadeProtocol {
    func checkCityNameExists(_ name: String, completion: @escaping (Bool) -> ())
    func insertCity(_ name: String, lat: Double, lon: Double, completion: @escaping () -> ())
    func getCityCoordinates(_ name: String, completion: @escaping (String, Double, Double) -> ())
    func getCityName(lat: Double, lon: Double, completion: @escaping (String, Double, Double) -> ())
    func getCities() -> [Cities]?
    func deleteCityFromList(_ index: Int, completion: @escaping () -> ())
    func swapCitiesInList(source: Int, destination: Int)
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
    
    func getCityName(lat: Double, lon: Double, completion: @escaping (String, Double, Double) -> ()) {
        do{
            guard let cities = (try context.fetch(Cities.fetchRequest())) as? [Cities] else { return }
            guard let city = cities.first(where: { $0.lat == lat && $0.lon == lon }) else{ return }
            completion(city.name, city.lat, city.lon)
        }catch{
            //error
        }
    }
    
    func getCityCoordinates(_ name: String, completion: @escaping (String, Double, Double) -> ()) {
        do{
            guard let cities = (try context.fetch(Cities.fetchRequest())) as? [Cities] else { return }
            guard let city = cities.first(where: { $0.name == name }) else{ return }
            completion(city.name, city.lat, city.lon)
        }catch{
            //error
        }
    }
    
    func insertCity(_ name: String, lat: Double, lon: Double, completion: @escaping () -> ()) {
        
        do {
            guard let cities = (try context.fetch(Cities.fetchRequest())) as? [Cities] else{ return }
            let city = Cities(context: context)
            city.name = name
            city.lat = lat
            city.lon = lon
            city.index = (cities.max(by: { $0.index < $1.index })?.index ?? -1) + 1
            try context.save()
            completion()
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
    
    func deleteCityFromList(_ index: Int, completion: @escaping () -> ()) {
        do{
            guard let cities = (try context.fetch(Cities.fetchRequest())) as? [Cities] else { return }
            guard let cityToDelete = cities.first(where: { $0.index == index } ) else { return }
            context.delete(cityToDelete)
            try context.save()
            completion()
        }catch{
            //error
        }
    }
    
    func swapCitiesInList(source: Int, destination: Int) {
        do{
            guard let cities = (try context.fetch(Cities.fetchRequest())) as? [Cities] else { return }
            guard let cityAt = cities.first(where: { $0.index == source } ) else { return }
            guard let cityTo = cities.first(where: { $0.index == destination } ) else { return }
            cityAt.index = destination
            cityTo.index = source
            try context.save()
        }catch{
            //error
        }
    }
}
