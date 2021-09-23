import Foundation
import CoreLocation
import Alamofire

protocol MapModelDelegate {
    func didLocationUpdate(lat: Double, lon: Double)
}

class MapModel: Model {
    
    private var locationManager: CLLocationManager = CLLocationManager()
    
    var delegate: MapModelDelegate!
    
    func updateWeatherDataInCity(_ cityName: String) {
        
    }
    
    func updateGeonames(east: Double, west: Double, north: Double, south: Double, completion: @escaping (CityListItem) -> Void) {
        
        guard let url = URL(string: ("http://api.geonames.org/citiesJSON?username=ivan&south=\(south)&north=\(north)&west=\(west)&east=\(east)").encodeUrl) else {
            print("Cannot covert string to URL")
            return
        }
        
        AF.request(url)
            .validate()
            .responseDecodable(of: Geonames.self) { (response) in
                if let data = response.value {
                    self.updateCurrentDataInGeonames(data, completion: completion)
                }
            }
    }
    
    func updateCurrentDataInGeonames(_ geonames: Geonames, completion: @escaping (CityListItem) -> Void) {
        
        for geoname in geonames.geonames {
            guard let url = URL(string: ("https://api.openweathermap.org/data/2.5/weather?lat=\(geoname.lat!)&lon=\(geoname.lon!)&appid=\(APIKey)&lang=\(lang)&units=\(units)").encodeUrl) else {
                print("Cannot covert string to URL")
                return
            }
            
            getCurrentDataFromAPI(url){ result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    func updateLocation() {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func getCityNameByCoord(lat: Double, lon: Double, completion: @escaping (String) -> Void) {
        
    }
}

extension MapModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            locationManager.startUpdatingLocation()
            locationManager = CLLocationManager()
            
            if let delegate = delegate {
                delegate.didLocationUpdate(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            }
        }
        
    }
}
