import Foundation

protocol GeneralDayViewProtocol: AnyObject {
    
    func refreshData(_ dataSource: DataSource)
    func updateCityName(_ name: String)
    func switchTheme()
    
}

protocol GeneralDayRouterProtocol {
    func showDayDetails(_ dataSource: DataSourceDay)
    func showSearchView()
    func showMapView()
}

class GeneralDayPresenter{
    
    var router: GeneralDayRouterProtocol!
    var model: GeneralDayModel!
    var view: GeneralDayViewProtocol!
    
    func updateWeatherData(_ data: WeatherData) {
        UserDataManager.saveCityName(name: data.cityName)
        self.view.refreshData(data)
    }
    
}

extension GeneralDayPresenter: GeneralDayPresenterProtocol {
    
    func didGeneralDayScreenLoad() {
        if let coord = UserDataManager.getSavedCoordinates() {
            model.updateDataByLocation(lat: coord.lat, lon: coord.lon) { [unowned self] result in
                self.view.refreshData(result)
            }
        }else{
            model.updateDataByCityName("Moscow") { [unowned self] result in
                self.view.refreshData(result)
            }
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
        if let cityName = UserDataManager.getSavedCityName() {
            model.updateDataByCityName(cityName) { [unowned self] result in
                self.view.refreshData(result)
            }
        }
    }
    
    func showDayDetails(_ dataSource: DataSourceDay) {
        router?.showDayDetails(dataSource)
    }
    
}
