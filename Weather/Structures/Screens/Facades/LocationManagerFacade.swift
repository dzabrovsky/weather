import Foundation
import CoreLocation

protocol LocationManagerFacadeProtocol {
    func getCurrentLocation(completion: @escaping (Coord) -> ())
}

class LocationManagerFacade: NSObject {
    
    static let shared: LocationManagerFacadeProtocol = LocationManagerFacade()
    
    private var locationManager: CLLocationManager = CLLocationManager()
    private var onUpdateLocation: ((Coord) -> ())!
    
    private override init(){
        super.init()
    }
}

extension LocationManagerFacade: LocationManagerFacadeProtocol {
    
    func getCurrentLocation(completion: @escaping (Coord) -> ()) {
        
        onUpdateLocation = { result in
            completion(result)
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManagerFacade: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.startUpdatingLocation()
            locationManager = CLLocationManager()
            
            let coord = Coord(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            onUpdateLocation(coord)
        }
    }
}
