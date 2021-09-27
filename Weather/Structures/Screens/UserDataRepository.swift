import Foundation

private let savedCoordKeyExists = "WeatherApp_coordinates_exists"
private let savedCityNameKeyExists = "WeatherApp_city_exists"

private let cityKeyName = "WeatherApp_city_name"
private let coordKeyLat = "WeatherApp_coordinates_latitude"
private let coordKeyLon = "WeatherApp_coordinates_longtitude"

class UserDataRepository {
    
    private let userDefaults = UserDefaults.standard
    
    func isKeyExists(key: String) -> Bool {
        return userDefaults.object(forKey: key) != nil
    }
    
    func getSavedCoordinates() -> Coord? {
        guard userDefaults.bool(forKey: savedCoordKeyExists) else { return nil }
        return Coord(
            lat: userDefaults.double(forKey: coordKeyLat),
            lon: userDefaults.double(forKey: coordKeyLon))
    }
    
    func getSavedCityName() -> String? {
        guard userDefaults.bool(forKey: savedCityNameKeyExists) else { return nil }
        return userDefaults.string(forKey: cityKeyName)
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
