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
    func addMarker(_ data: Geoname)
    func removeMarkers()
}

class MapPresenter {
    private let router: MapRouterProtocol
    private let model: MapModel
    weak var view: MapViewProtocol!
    
    let userDataRepository: UserDataRepositoryProtocol
    
    init(router: MapRouterProtocol, model: MapModel, userDataRepository: UserDataRepositoryProtocol) {
        self.router = router
        self.model = model
        self.userDataRepository = userDataRepository
    }
}

extension MapPresenter: MapPresenterProtocol {
    
    func didMapScreenLoad() {
        if let coord = userDataRepository.getSavedCoordinates(), let cityName = userDataRepository.getSavedCityName() {
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
        model.updateLocation{ result in
            self.view.moveToLocation(lat: result.lat, lon: result.lon)
        }
    }
    
    func onTapByMyLocationButton() {
        model.updateLocation{ result in
            self.view.moveToLocation(lat: result.lat, lon: result.lon)
        }
    }
    
    func onTapAnnotation(lat: Double, lon: Double) {
        model.insertCity(lat: lat, lon: lon) { result, info in
            guard let data = result else { return }
            self.userDataRepository.saveCity(lat: data.lat, lon: data.lon)
            self.userDataRepository.saveCityName(name: data.name)
            self.router.popToRootWithSelectedCity()
        }
    }
    
    func mapViewDidFinishLoadingMap(centerLon: Double, centerLat: Double, latA: Double, lonA: Double) {
        
        view.removeMarkers()
        
        model.updateGeonames(
            east: centerLon + lonA/2,
            west: centerLon - lonA/2,
            north: centerLat + latA/2,
            south: centerLat - latA/2
        ){ result in
            let data = result.convertToGeonames()
            if let view = self.view {
                view.addMarker(data)
            }
        }
    }
    
}
