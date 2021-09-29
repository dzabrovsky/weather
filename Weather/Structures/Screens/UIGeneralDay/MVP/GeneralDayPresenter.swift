import Foundation

protocol GeneralDayViewProtocol: AnyObject {
    
    func refreshData(_ dataSource: ForecastDataSource)
    func updateCityName(_ name: String)
    func switchTheme()
    
}

protocol GeneralDayRouterProtocol {
    func showDayDetails(_ dataSource: ForecastDayDataSource, cityName: String)
    func showSearchView()
    func showMapView()
}

class GeneralDayPresenter{
    
    var router: GeneralDayRouterProtocol!
    var model: GeneralDayModel!
    var view: GeneralDayViewProtocol!
    
    func updateWeatherData(_ data: ForecastCodable) {
        let dataSource = data.convertToForecast()
        UserDataRepository.shared.saveCityName(name: dataSource.cityName)
        self.view.refreshData(dataSource)
    }
    
}

extension GeneralDayPresenter: GeneralDayPresenterProtocol {
    
    func didGeneralDayScreenLoad() {
        if let coord = UserDataRepository.shared.getSavedCoordinates() {
            model.updateDataByLocation(lat: coord.lat, lon: coord.lon) { [unowned self] result in
                UserDataRepository.shared.saveCityName(name: result.city.name)
                self.view.refreshData(result.convertToForecast())
            }
        }else{
            model.updateDataByCityName("Moscow") { [unowned self] result in
                self.view.refreshData(result.convertToForecast())
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
        if let cityName = UserDataRepository.shared.getSavedCityName() {
            model.updateDataByCityName(cityName) { [unowned self] result in
                self.view.refreshData(result.convertToForecast())
            }
        }
    }
    
    func showDayDetails(_ dataSource: ForecastDayDataSource, cityName: String) {
        router?.showDayDetails(dataSource, cityName: cityName)
    }
    
}
