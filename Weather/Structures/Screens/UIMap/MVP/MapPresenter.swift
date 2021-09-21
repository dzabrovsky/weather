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
    func addMarker(_ dataSource: GeoNameDataSource)
}

class MapPresenter {
    let router: MapRouterProtocol
    let model: MapModel
    weak var view: MapViewProtocol!
    var updateGeoNames: (() -> GeoNames?)?
    
    init(router: MapRouterProtocol, model: MapModel) {
        self.router = router
        self.model = model
    }
}

extension MapPresenter: MapPresenterProtocol {
    
    func didMapScreenLoad() {
        if let coord = UserDataManager.getSavedCoordinates(), let cityName = UserDataManager.getSavedCityName() {
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
    
    func onSelectCity(lat: Double, lon: Double) {
        UserDataManager.saveCity(lat: lat, lon: lon)
        
        router.popToRootWithSelectedCity()
    }
    
    func onTapAnnotation(lat: Double, lon: Double) {
        
    }
    
    func mapViewDidFinishLoadingMap(centerLon: Double, centerLat: Double, latA: Double, lonA: Double) {
        
        model.updateGeoNames(
            east: centerLon + lonA/2,
            west: centerLon - lonA/2,
            north: centerLat + latA/2,
            south: centerLat - latA/2
        ){ [unowned self] result in
            let data = GeoNamesAdapter.convertToDataSource(data: result)
            self.view.addMarker(data)
        }
    }
    
}

extension MapPresenter: MapModelDelegate {
    
    func didLocationUpdate(lat: Double, lon: Double) {
        view.moveToLocation(lat: lat, lon: lon)
    }
}
