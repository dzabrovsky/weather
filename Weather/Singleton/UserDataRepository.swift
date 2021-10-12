import Foundation

protocol UserDataRepositoryProtocol {
    func getSavedCoordinates() -> Coordindates?
    func getSavedCityName() -> String?
    func saveCity(lat: Double, lon: Double)
    func saveCityName(name: String)
    
    func getLang() -> String
    func getUnits() -> String
    func getAPIKey() -> String
    
    func getDefaultCoordinates() -> Coordindates
    func getDefaultCityName() -> String
}

private let cityKeyName = "WeatherApp_city_name"
private let coordKeyLat = "WeatherApp_coordinates_latitude"
private let coordKeyLon = "WeatherApp_coordinates_longtitude"

private let defaultCityName = "Moscow"
private let defaultCoordinates = Coordindates(lat: 55.751244, lon: 37.618423)

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
    func setDefaultData() {
        saveCity(lat: defaultCoordinates.lat, lon: defaultCoordinates.lon)
        saveCityName(name: defaultCityName)
    }
    
    func getDefaultCityName() -> String {
        return defaultCityName
    }
    
    func getDefaultCoordinates() -> Coordindates {
        return defaultCoordinates
    }
    
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
        
        if !isKeyExists(key: coordKeyLat){
            setDefaultData()
        }
        return Coordindates(
            lat: userDefaults.double(forKey: coordKeyLat),
            lon: userDefaults.double(forKey: coordKeyLon))
    }
    
    func getSavedCityName() -> String? {
        if !isKeyExists(key: cityKeyName){
            setDefaultData()
        }
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
