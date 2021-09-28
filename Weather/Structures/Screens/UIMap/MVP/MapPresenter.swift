import Foundation

protocol MapRouterProtocol {
    func popToRoot()
    func popToRootWithSelectedCity()
}

protocol MapViewProtocol: AnyObject {
    func setRegion(lat: Double, lon: Double, size: Int)
    func moveToLocation(lat: Double, lon: Double)
    func showAlertMissingSaves()
    func setCityName(_ name: String)
    func addMarker(_ data: GeonameDataSource)
}

class MapPresenter {
    let router: MapRouterProtocol
    let model: MapModel
    weak var view: MapViewProtocol!
    var updateGeoNames: (() -> Geonames?)?
    
    init(router: MapRouterProtocol, model: MapModel) {
        self.router = router
        self.model = model
    }
}

extension MapPresenter: MapPresenterProtocol {
    
    func didMapScreenLoad() {
        if let coord = UserDataRepository.shared.getSavedCoordinates(), let cityName = UserDataRepository.shared.getSavedCityName() {
            view.setRegion(lat: coord.lat, lon: coord.lon, size: 100000)
            view.setCityName(cityName)
        }else{
            view.showAlertMissingSaves()
        }
    }
    
    func onTapBackButton() {
        router.popToRoot()
    }
    
    func onTapLocationButton() {
        model.updateLocation()
    }
    
    func onTapByMyLocationButton() {
        model.updateLocation()
    }
    
    func onTapAnnotation(lat: Double, lon: Double) {
        UserDataRepository.shared.saveCity(lat: lat, lon: lon)
        router.popToRootWithSelectedCity()
    }
    
    func mapViewDidFinishLoadingMap(centerLon: Double, centerLat: Double, latA: Double, lonA: Double) {
        
        model.updateGeonames(
            east: centerLon + lonA/2,
            west: centerLon - lonA/2,
            north: centerLat + latA/2,
            south: centerLat - latA/2
        ){ [unowned self] result in
            let data = result.convertToGeonames()
            if let view = self.view {
                view.addMarker(data)
            }
        }
    }
    
}

extension MapPresenter: MapModelDelegate {
    
    func didLocationUpdate(lat: Double, lon: Double) {
        view.moveToLocation(lat: lat, lon: lon)
    }
}
