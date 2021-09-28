import UIKit
import MapKit

protocol MapPresenterProtocol {
    
    func didMapScreenLoad()
    
    func onTapBackButton()
    func onTapLocationButton()
    func onTapByMyLocationButton()
    
    func onTapAnnotation(lat: Double, lon: Double)
    func mapViewDidFinishLoadingMap(centerLon: Double, centerLat: Double, latA: Double, lonA: Double)
}

class UIMapViewController: UIViewController {
    
    var presenter: MapPresenterProtocol!
    
    private var mapView = UIMapView()
    
    private var dataSource: [GeonameDataSource] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setActions()
        presenter.didMapScreenLoad()
    }
    
    override func loadView() {
        super.loadView()
        
        view = mapView
    }
    
    private func setup() {
        mapView.map.delegate = self
    }
    
    private func setActions() {
        mapView.header.backButton.addTarget(self, action: #selector(onTapBackButton(sender:)), for: .touchUpInside)
        mapView.header.locationButton.addTarget(self, action: #selector(onTapLocationButton(sender:)), for: .touchUpInside)
    }
    
    @objc private func onTapBackButton(sender: UIHeaderButton){
        presenter.onTapBackButton()
    }
    
    @objc private func onTapByMyLocationButton(sender: UIHeaderButton){
        presenter.onTapByMyLocationButton()
    }
    
    @objc private func onTapLocationButton(sender: UIHeaderButton){
        presenter.onTapLocationButton()
    }
    
    private func updateLocationOnMap(lat: Double, lon: Double) {
        mapView.map.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: lon), animated: true)
    }
}

extension UIMapViewController: MapViewProtocol {
    
    func removeMarkers() {
        mapView.map.removeAnnotations(mapView.map.annotations)
    }
    
    func addMarker(_ data: GeonameDataSource) {
        mapView.addAnnotationFromData(data)
        self.dataSource.append(data)
    }
    
    func setCityName(_ name: String) {
        mapView.header.title.text = name
    }
    
    func moveToLocation(lat: Double, lon: Double) {
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        mapView.map.setCenter(center, animated: true)
    }
    
    func setRegion(lat: Double, lon: Double, size: Int) {
        
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: CLLocationDistance.init(size),
            longitudinalMeters: CLLocationDistance.init(size)
        )
        
        mapView.map.setRegion(region, animated: true)
    }
    
    func showAlertMissingSaves() {
        let alert = UIAlertController(title: "Что-то пошло не так...", message: "Не удалось найти установленный город!", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(
            alert,
            animated: true,
            completion: {
                self.presenter.onTapBackButton()
            }
        )
    }
}

extension UIMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            presenter.onTapAnnotation(
                lat: annotation.coordinate.latitude,
                lon: annotation.coordinate.longitude
            )
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        presenter.mapViewDidFinishLoadingMap(
            centerLon: mapView.region.center.longitude,
            centerLat: mapView.region.center.latitude,
            latA: mapView.region.span.latitudeDelta,
            lonA: mapView.region.span.longitudeDelta)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "UIAnnotationView") as! UIAnnotationView
        
        if let data = dataSource.first(
            where: {
                $0.lat == annotation.coordinate.latitude && $0.lon == annotation.coordinate.longitude
            }
        ) {
            annotationView.setValues(icon: data.icon, temperature: data.temperature, feelsLike: data.feelsLike)
        }
        return annotationView
    }
    
}
