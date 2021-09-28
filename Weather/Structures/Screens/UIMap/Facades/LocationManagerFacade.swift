import Foundation
import CoreLocation

class LocationManagerFacade: NSObject {
    
    private var locationManager: CLLocationManager = CLLocationManager()
    
    private var onUpdateLocation: ((Coord) -> ())!
    
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
