// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let topLevel = try? newJSONDecoder().decode(APIData.self, from: jsonData)

import UIKit
import CoreLocation
import Alamofire

protocol GeneralDayPresenterProtocolForModel: AnyObject {
    
    func didDataUpdated()
    func didDataByLocationUpdated()
    func didGeoNamesUpdated()
    func didGeoNamesWeatherUpdated(_ dataSource: WeatherInGeoNamesProtocol)
    func didLocationUpdated(lat: Double, lon: Double)
    
}

class GeneralDayModel: Model {
    
    unowned var presenter: GeneralDayPresenterProtocolForModel!
    
    private let lang: String = "ru"
    private let units: String = "metric"
    private let defaultCityName: String = "Moscow"
    private var cityName:String = "Tambov"
    private let APIKey:String = "830e252225a6214c4370ecfee9b1d912"
    
    private var data = WeatherData()
    private var geonames: GeoNames!
    private var dataGeoNames = WeatherInGeoNames()
    
    private var locationManager: CLLocationManager = CLLocationManager()
    
    func didDataUpdated() {
        presenter.didDataUpdated()
    }
    func didDataByLocationUpdated() {
        presenter.didDataByLocationUpdated()
    }
    
    func didGeoNamesUpdated() {
        presenter.didGeoNamesUpdated()
    }
    
    func getGeoNames (_ url:URL, completion: @escaping (GeoNames) -> Void) {
        
        print("--===", url, "\n===--")
        
        AF.request(url)
            .validate()
            .responseDecodable(of: GeoNames.self) { (response) in
                if let data = response.value {
                    completion(data)
                }
            }
    }
    
    
}

extension GeneralDayModel: GeneralDayModelProtocol {
    
    func updateDataByCityName() {
        
        guard let url = URL(string: ("https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=\(APIKey)&lang=\(lang)&units=\(units)").encodeUrl) else {
            print("Cannot covert string to URL")
            return
        }
        
        getDataFromAPI(url){ result in
            DispatchQueue.main.async {
                self.data = result
                self.didDataUpdated()
            }
        }
    }
    
    func updateDataByCityName(_ cityName: String) {
        self.cityName = cityName
        updateDataByCityName()
    }
    
    func updateLocation() {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func updateGeoNames(east: Double, west: Double, north: Double, south: Double) {
        
        guard let url = URL(string: ("http://api.geonames.org/citiesJSON?username=ivan&south=\(south)&north=\(north)&west=\(west)&east=\(east)").encodeUrl) else {
            print("Cannot covert string to URL")
            return
        }
        
        
        getGeoNames(url){ result in
            DispatchQueue.main.async {
                self.geonames = result
                self.didGeoNamesUpdated()
            }
        }
        
    }
    
    func updateCurrentDataInGeoNames() {
        
        if let geonamesData = geonames.geonames {
            for geoname in geonamesData {
                guard let url = URL(string: ("https://api.openweathermap.org/data/2.5/weather?lat=\(geoname.lat)&lon=\(geoname.lon)&appid=\(APIKey)&lang=\(lang)&units=\(units)").encodeUrl) else {
                    print("Cannot covert string to URL")
                    return
                }
                
                getCurrentDataFromAPI(url){ result in
                    DispatchQueue.main.async {
                        self.dataGeoNames.data.append(result)
                        
                        self.presenter.didGeoNamesWeatherUpdated(self.dataGeoNames)
                    }
                }
            }
        }
    }
    
    func updateDataByLocation(lat: Double, lon: Double){
        
        guard let url = URL(string: ("https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(APIKey)&lang=\(lang)&units=\(units)").encodeUrl) else {
            print("Cannot covert string to URL")
            return
        }
        
        getDataFromAPI(url){ result in
            DispatchQueue.main.async {
                self.data = result
                self.didDataByLocationUpdated()
            }
        }
    }
    
    func getCurrentData() -> WeatherData {
        return self.data
    }
    
    func getCurrentCityName() -> String {
        return data.cityName
    }
}

extension GeneralDayModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            locationManager.startUpdatingLocation()
            locationManager = CLLocationManager()
            
            presenter.didLocationUpdated(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        }
        
    }
}

extension String{
    var encodeUrl : String
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String
    {
        return self.removingPercentEncoding!
    }
}
