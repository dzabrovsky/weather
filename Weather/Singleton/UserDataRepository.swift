import Foundation

protocol UserDataRepositoryProtocol {
    func getSavedCoordinates() -> Coordindates?
    func getSavedCityName() -> String?
    func saveCity(lat: Double, lon: Double)
    func saveCityName(name: String)
    
    func getLang() -> String
    func getUnits() -> String
    func getAPIKey() -> String
}

private let cityKeyName = "WeatherApp_city_name"
private let coordKeyLat = "WeatherApp_coordinates_latitude"
private let coordKeyLon = "WeatherApp_coordinates_longtitude"

class UserDataRepository {
    
    static let shared: UserDataRepositoryProtocol = UserDataRepository()
    
    private let userDefaults = UserDefaults.standard
    
    let lang: String = "ru"
    let units: String = "metric"
    let APIKey:String = "830e252225a6214c4370ecfee9b1d912"
    
    private init(){
        
    }
    
    private func isKeyExists(key: String) -> Bool {
        return userDefaults.object(forKey: key) != nil
    }
    
}

extension UserDataRepository: UserDataRepositoryProtocol {
    
    func getLang() -> String {
        return lang
    }
    
    func getUnits() -> String {
        return units
    }
    
    func getAPIKey() -> String {
        return APIKey
    }
    
    func getSavedCoordinates() -> Coordindates? {
        
        guard isKeyExists(key: coordKeyLat) else { return nil }
        return Coordindates(
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
