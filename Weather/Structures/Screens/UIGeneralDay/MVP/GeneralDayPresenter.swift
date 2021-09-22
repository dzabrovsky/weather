import Foundation

protocol GeneralDayViewProtocol: AnyObject {
    
    func refreshData(_ dataSource: ForecastDataSource)
    func updateCityName(_ name: String)
    func switchTheme()
    
}

protocol GeneralDayRouterProtocol {
    func showDayDetails(_ dataSource: ForecastDayDataSource)
    func showSearchView()
    func showMapView()
}

class GeneralDayPresenter{
    
    var router: GeneralDayRouterProtocol!
    var model: GeneralDayModel!
    var view: GeneralDayViewProtocol!
    
    func updateWeatherData(_ data: Forecast) {
        let dataSource = ForecastAdapter.convertToForecast(from: data)
        UserDataManager.saveCityName(name: dataSource.cityName)
        self.view.refreshData(dataSource)
    }
    
}

extension GeneralDayPresenter: GeneralDayPresenterProtocol {
    
    func didGeneralDayScreenLoad() {
        if let coord = UserDataManager.getSavedCoordinates() {
            model.updateDataByLocation(lat: coord.lat, lon: coord.lon) { [unowned self] result in
                self.view.refreshData(ForecastAdapter.convertToForecast(from: result))
            }
        }else{
            model.updateDataByCityName("Moscow") { [unowned self] result in
                self.view.refreshData(ForecastAdapter.convertToForecast(from: result))
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
                self.view.refreshData(ForecastAdapter.convertToForecast(from: result))
            }
        }
    }
    
    func showDayDetails(_ dataSource: ForecastDayDataSource) {
        router?.showDayDetails(dataSource)
    }
    
}
