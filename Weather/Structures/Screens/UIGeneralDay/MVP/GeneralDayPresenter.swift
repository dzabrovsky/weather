import Foundation

protocol GeneralDayViewProtocol: AnyObject {
    
    func refreshData(_ dataSource: DataSource)
    func refreshCitiesOnMap(_ dataSorce: WeatherInGeoNamesProtocol)
    func updateCityName(_ name: String)
    func switchTheme()
    func openMap()
    func closeMap()
    func updateLocationOnMap(lat: Double, lon: Double)
    
}

protocol GeneralDayModelProtocol: AnyObject {
    func updateDataByCityName()
    func updateDataByCityName(_ cityName: String)
    func updateLocation()
    func updateDataByLocation(lat: Double, lon: Double)
    
    func updateGeoNames(east: Double, west: Double, north: Double, south: Double)
    
    func updateCurrentDataInGeoNames(_ geonames: GeoNames)
}

protocol GeneralDayRouterProtocol {
    func showDayDetails(_ dataSource: DataSourceDay)
    func showSearchView()
}

class GeneralDayPresenter{

    var router: GeneralDayRouterProtocol!
    var model: GeneralDayModelProtocol!
    var view: GeneralDayViewProtocol!
    
}

extension GeneralDayPresenter: GeneralDayPresenterProtocolForModel {
    
    func didGeoNamesUpdated(_ geonames: GeoNames) {
        model.updateCurrentDataInGeoNames(geonames)
    }
    
    func didGeoNamesWeatherUpdated(_ dataSource: WeatherInGeoNamesProtocol) {
        view.refreshCitiesOnMap(dataSource)
    }
    
    func onTapAnnotation(lat: Double, lon: Double) {
        model.updateDataByLocation(lat: lat, lon: lon)
    }
    
    func didLocationUpdated(lat: Double, lon: Double) {
        view.updateLocationOnMap(lat: lat, lon: lon)
    }
    
    func didDataUpdated(_ data: WeatherData) {
        self.view.refreshData(data)
    }
    
    func didDataByLocationUpdated(_ data: WeatherData){
        self.view.closeMap()
        self.didDataUpdated(data)
    }
    
}

extension GeneralDayPresenter: GeneralDayPresenterProtocol {
    
    func onTapBackButton() {
        view.closeMap()
    }
    
    func onTapOpenMapButton() {
        view.openMap()
    }
    
    func onTapLocationButton() {
        model.updateLocation()
    }
    
    func onApplyNewCityName(_ cityName: String) {
        model.updateDataByCityName(cityName)
    }
    
    func onTapCityListButton() {
        router?.showSearchView()
    }
    
    func onTapThemeButton() {
        view.switchTheme()
    }
    
    func updateDataByUser() {
        model.updateDataByCityName()
    }
    
    func mapViewDidFinishLoadingMap(centerLon: Double, centerLat: Double, lonA: Double, latA: Double) {
        model.updateGeoNames(east: centerLon + lonA/2, west: centerLon - lonA/2, north: centerLat - latA/2, south: centerLat + latA/2)
    }
    
    func showDayDetails(_ dataSource: DataSourceDay) {
        router?.showDayDetails(dataSource)
    }
    
}
