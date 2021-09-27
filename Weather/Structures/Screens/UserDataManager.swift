import Foundation

private let savedCoordKeyExists = "WeatherApp_coordinates_exists"
private let savedCityNameKeyExists = "WeatherApp_city_exists"

private let cityKeyName = "WeatherApp_city_name"
private let coordKeyLat = "WeatherApp_coordinates_latitude"
private let coordKeyLon = "WeatherApp_coordinates_longtitude"

class UserDataManager {
    
    private let userDefaults = UserDefaults.standard
    
    func getSavedCoordinates() -> Coord? {
        
        if userDefaults.bool(forKey: savedCoordKeyExists) {
            let lat = userDefaults.double(forKey: coordKeyLat)
            let lon = userDefaults.double(forKey: coordKeyLon)
            return Coord(lat: lat, lon: lon)
        }else{
            return nil
        }
    }
    
    func getSavedCityName() -> String? {
        if userDefaults.bool(forKey: savedCityNameKeyExists) {
            let name = userDefaults.string(forKey: cityKeyName)
            return name
        }else{
            return nil
        }
    }
    
    func saveCity(lat: Double, lon: Double) {
        userDefaults.set(lat, forKey: coordKeyLat)
        userDefaults.set(lon, forKey: coordKeyLon)
        userDefaults.set(true, forKey: savedCoordKeyExists)
    }
    
    func saveCityName(name: String) {
        userDefaults.set(name, forKey: cityKeyName)
        userDefaults.set(true, forKey: savedCityNameKeyExists)
    }
}
