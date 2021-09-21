import Foundation

protocol GeneralDayViewProtocol: AnyObject {
    
    func refreshData(_ dataSource: DataSource)
    func updateCityName(_ name: String)
    func switchTheme()
    
}

protocol GeneralDayModelProtocol: AnyObject {
    func updateDataByCityName()
    func updateDataByCityName(_ cityName: String)
    func updateDataByLocation(lat: Double, lon: Double)
}

protocol GeneralDayRouterProtocol {
    func showDayDetails(_ dataSource: DataSourceDay)
    func showSearchView()
    func showMapView()
}

class GeneralDayPresenter{

    var router: GeneralDayRouterProtocol!
    var model: GeneralDayModelProtocol!
    var view: GeneralDayViewProtocol!
    
}

extension GeneralDayPresenter: GeneralDayPresenterProtocolForModel {
    
    func didDataUpdated(_ data: WeatherData) {
        UserDataManager.saveCityName(name: data.cityName)
        self.view.refreshData(data)
    }
    
}

extension GeneralDayPresenter: GeneralDayPresenterProtocol {
    
    func didGeneralDayScreenLoad() {
        if let coord = UserDataManager.getSavedCoordinates() {
            model.updateDataByLocation(lat: coord.lat, lon: coord.lon)
        }else{
            model.updateDataByCityName("Moscow")
        }
    }
    
    func onTapCityListButton() {
        router?.showSearchView()
    }
    
    func onTapThemeButton() {
        view.switchTheme()
    }
    
    func onTapLocationButton() {
        router.showMapView()
    }
    
    func updateDataByUser() {
        model.updateDataByCityName()
    }
    
    func showDayDetails(_ dataSource: DataSourceDay) {
        router?.showDayDetails(dataSource)
    }
    
}
