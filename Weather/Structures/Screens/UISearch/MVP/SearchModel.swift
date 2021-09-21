import UIKit
import CoreData

protocol SearchPresenterProtocolForModel: AnyObject {
    func didCityLastUseUpdate(lat: Double, lon: Double)
    func cityListUpdated(_ dataSource: CityListItemDataSourceProtocol)
    func cityAlreadyExists()
    func cityDoesNotExists()
}

class SearchModel: Model, SearchModelProtocol{
    
    private var dataSource = CityListItemDataSource()
    unowned var presenter: SearchPresenterProtocolForModel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func didCityListUpdate() {
        presenter.cityListUpdated(dataSource)
    }
    
    func updateWeatherInCity(_ city: Cities) {
        
        guard let url = URL(string: ("https://api.openweathermap.org/data/2.5/weather?q=\(city.name!)&appid=\(APIKey)&lang=\(lang)&units=\(units)").encodeUrl) else {
            print("Cannot covert string to URL")
            return
        }
        getCurrentDataFromAPI(url){ result in
            DispatchQueue.main.async {
                self.dataSource.data.append(result)
                self.didCityListUpdate()
            }
        }
    }
    
    func updateWeatherInCity(_ name: String) {
        
        guard let url = URL(string: ("https://api.openweathermap.org/data/2.5/weather?q=\(name)&appid=\(APIKey)&lang=\(lang)&units=\(units)").encodeUrl) else {
            print("Cannot covert string to URL")
            return
        }
        getCurrentDataFromAPI(url){ result in
            DispatchQueue.main.async {
                self.dataSource.data.append(result)
                self.didCityListUpdate()
            }
        }
    }
    
    func updateCityList(){
        dataSource = CityListItemDataSource()
        do {
            if var cities = (try context.fetch(Cities.fetchRequest())) as? [Cities] {
                cities.sort(by: { $0.lastUse! > $1.lastUse! })
                for item in cities {
                    print(item.lastUse!)
                    updateWeatherInCity(item)
                }
            }
        }catch{
            // error
        }
    }
    
    func checkCity(_ name: String) {
        do {
            if let cities = (try context.fetch(Cities.fetchRequest())) as? [Cities] {
                if let _ = cities.first(where: { $0.name == name } ) {
                    presenter.cityAlreadyExists()
                }else{
                    guard let url = URL(string: ("http://api.geonames.org/searchJSON?q=\(name)&username=ivan&style=MEDIUM&lang=ru").encodeUrl) else {
                        print("Cannot covert string to URL")
                        return
                    }
                    
                    searchCity(url) { (result) in
                        DispatchQueue.main.async {
                            if result.geonames.count > 0 {
                                if result.geonames.contains(where: { $0.name == name}) {
                                    self.insertCityInCitiesList(name: name)
                                }
                            }else{
                                self.presenter.cityDoesNotExists()
                            }
                        }
                    }
                }
            }
        }catch{
            
        }
    }
    
    func insertCityInCitiesList(name: String){
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
                self.updateWeatherInCity(name)
            }
            try context.save()
        }catch{
            // error
        }
    }
    
    func deleteCityFromCitiesList(id: Int32){
        
        do {
            try context.save()
        }catch{
            // error
        }
    }
    func updateCityLastUse(_ name: String){
        do {
            if let cities = (try context.fetch(Cities.fetchRequest())) as? [Cities] {
                if let city = cities.filter({ $0.name == name }).first {
                    city.lastUse = Date()
                    try context.save()
                    DispatchQueue.main.async {
                        self.presenter.didCityLastUseUpdate(lat: city.lat, lon: city.lon)
                    }
                }
            }
        }catch{
            // error
        }
    }
    
    func clearCoreData() {
        do {
            let cities = try context.fetch(Cities.fetchRequest())
            for item in cities {
                let city = item as! Cities
                context.delete(city)
                try context.save()
            }
        }catch{
            
        }
    }
    
}
