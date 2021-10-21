import UIKit
import MapKit

class MapMarkersAdapter: NSObject {
    private var data: [Geoname] = []
    
    var onTapMarker: ((Double, Double) -> ())?
    var onFinishLoadingMap: ((Double, Double, Double, Double) -> ())?
    
    func addData(_ data: Geoname) {
        
        self.data.append(data)
    }
}

extension MapMarkersAdapter: MKMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        guard let onFinishLoadingMap = onFinishLoadingMap else { return }
        onFinishLoadingMap(
            mapView.region.center.longitude,
            mapView.region.center.latitude,
            mapView.region.span.latitudeDelta,
            mapView.region.span.longitudeDelta
        )
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "UIAnnotationView") as! UIAnnotationView
        
        if let data = data.first(
            where: {
                $0.lat == annotation.coordinate.latitude && $0.lon == annotation.coordinate.longitude
            }
        ) {
            annotationView.setValues(icon: data.icon, temperature: data.temperature, feelsLike: data.feelsLike)
            let tapGesture = TapMarkerGesture(
                target: self,
                action: nil,
                lat: annotation.coordinate.latitude,
                lon: annotation.coordinate.longitude
            )
            tapGesture.tapDelegate = self
            annotationView.addGestureRecognizer(tapGesture)
        }
        return annotationView
    }
    
}

extension MapMarkersAdapter: TapMarkerGestureDelegate {
    func onTap(_ gesture: TapMarkerGesture) {
        guard let onTapMarker = onTapMarker else { return }
        onTapMarker(gesture.lat, gesture.lon)
    }
}
