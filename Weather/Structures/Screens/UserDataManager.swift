import Foundation

let savedCoordKeyExists = "WeatherApp_coordinates_exists"
let savedCityNameKeyExists = "WeatherApp_city_exists"

let cityKeyName = "WeatherApp_city_name"
let coordKeyLat = "WeatherApp_coordinates_latitude"
let coordKeyLon = "WeatherApp_coordinates_longtitude"

class UserDataManager {
    
    static func getSavedCoordinates() -> Coord? {
        
        if UserDefaults.standard.bool(forKey: savedCoordKeyExists) {
            let lat = UserDefaults.standard.double(forKey: coordKeyLat)
            let lon = UserDefaults.standard.double(forKey: coordKeyLon)
            return Coord(lat: lat, lon: lon)
        }else{
            return nil
        }
    }
    
    static func getSavedCityName() -> String? {
        if UserDefaults.standard.bool(forKey: savedCityNameKeyExists) {
            let name = UserDefaults.standard.string(forKey: cityKeyName)
            return name
        }else{
            return nil
        }
    }
    
    static func saveCity(lat: Double, lon: Double) {
        UserDefaults.standard.set(lat, forKey: coordKeyLat)
        UserDefaults.standard.set(lon, forKey: coordKeyLon)
        UserDefaults.standard.set(true, forKey: savedCoordKeyExists)
    }
    static func saveCityName(name: String) {
        UserDefaults.standard.set(name, forKey: cityKeyName)
        UserDefaults.standard.set(true, forKey: savedCityNameKeyExists)
    }
}
