import Foundation

private let cityKeyName = "WeatherApp_city_name"
private let coordKeyLat = "WeatherApp_coordinates_latitude"
private let coordKeyLon = "WeatherApp_coordinates_longtitude"

class UserDataRepository {
    
    static let shared: UserDataRepository = UserDataRepository()
    
    private let userDefaults = UserDefaults.standard
    
    func isKeyExists(key: String) -> Bool {
        return userDefaults.object(forKey: key) != nil
    }
    
    func getSavedCoordinates() -> Coord? {
        
        guard isKeyExists(key: coordKeyLat) else { return nil }
        return Coord(
            lat: userDefaults.double(forKey: coordKeyLat),
            lon: userDefaults.double(forKey: coordKeyLon))
    }
    
    func getSavedCityName() -> String? {
        guard isKeyExists(key: cityKeyName) else { return nil }
        return userDefaults.string(forKey: cityKeyName)
    }
    
    func saveCity(lat: Double, lon: Double) {
        userDefaults.set(lat, forKey: coordKeyLat)
        userDefaults.set(lon, forKey: coordKeyLon)
    }
    
    func saveCityName(name: String) {
        userDefaults.set(name, forKey: cityKeyName)
    }
}
