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
        mapView.mapView.delegate = self
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
        mapView.mapView.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: lon), animated: true)
    }
}

extension UIMapViewController: MapViewProtocol {
    
    func addMarker(_ dataSource: GeonameDataSource) {
        mapView.loadAnnotationFromDataSource(dataSource)
        self.dataSource.append(dataSource)
    }
    
    func setCityName(_ name: String) {
        mapView.header.title.text = name
    }
    
    func moveToLocation(lat: Double, lon: Double) {
        mapView.mapView.setCenter(
            CLLocationCoordinate2D(
                latitude: lat,
                longitude: lon
            ),
            animated: true
        )
    }
    
    func setRegion(lat: Double, lon: Double, size: Int) {
        
        mapView.mapView.setRegion(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: lat,
                    longitude: lon
                ),
                latitudinalMeters: CLLocationDistance.init(size),
                longitudinalMeters: CLLocationDistance.init(size)
            ),
            animated: true
        )
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
        mapView.removeAnnotations(mapView.annotations)
        
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
            annotationView.setValues(icon: data.icon, temp: data.temp, feelsLike: data.feelsLike)
        }
        return annotationView
    }
    
}
