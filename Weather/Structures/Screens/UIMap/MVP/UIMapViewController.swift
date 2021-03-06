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
    private let mapAdapter: MapMarkersAdapter = MapMarkersAdapter()
    private var mapView = UIMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        presenter.didMapScreenLoad()
    }
    
    override func loadView() {
        super.loadView()
        
        view = mapView
    }
    
    private func setup() {
        mapView.map.delegate = mapAdapter
        mapAdapter.onTapMarker = { lat, lon in
            self.presenter.onTapAnnotation(lat: lat, lon: lon)
        }
        mapAdapter.onFinishLoadingMap = { lon, lat, latA, lonA in
            self.presenter.mapViewDidFinishLoadingMap(centerLon: lon, centerLat: lat, latA: latA, lonA: lonA)
        }
        mapView.header.delegate = self
    }
    
    private func updateLocationOnMap(lat: Double, lon: Double) {
        mapView.map.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: lon), animated: true)
    }
}

extension UIMapViewController: MapViewProtocol {
    
    func removeMarkers() {
        mapView.map.removeAnnotations(mapView.map.annotations)
    }
    
    func addMarker(_ data: Geoname) {
        mapAdapter.addData(data)
        mapView.addAnnotationFromData(data)
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
        let alert = UIAlertController(title: "??????-???? ?????????? ???? ??????...", message: "???? ?????????????? ?????????? ?????????????????????????? ??????????!", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "????????????", style: .cancel, handler: nil)
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

extension UIMapViewController: UIHeaderDelegate {
    func buttonsForHeader() -> [HeaderButton]? {
        var buttons = [HeaderButton]()
        buttons.append(HeaderButton(icon: #imageLiteral(resourceName: "outline_arrow_back_ios_black_48pt"), side: .left){
            self.presenter.onTapBackButton()
        })
        buttons.append(HeaderButton(icon: #imageLiteral(resourceName: "outline_place_black_48pt"), side: .right){
            self.presenter.onTapLocationButton()
        })
        return buttons
    }
}
