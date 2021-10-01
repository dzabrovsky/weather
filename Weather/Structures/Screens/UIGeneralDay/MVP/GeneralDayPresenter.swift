import Foundation

protocol GeneralDayViewProtocol: AnyObject {
    
    func refreshData(_ dataSource: Forecast)
    func updateCityName(_ name: String)
    func switchTheme()
    
}

protocol GeneralDayRouterProtocol {
    func showDayDetails(_ dataSource: ForecastDay, cityName: String)
    func showSearchView()
    func showMapView()
}

protocol GeneralDayModelProtocol {
    func updateDataByLocation(lat: Double, lon: Double, completion: @escaping (ForecastCodable) -> Void)
}

class GeneralDayPresenter{
    
    var router: GeneralDayRouterProtocol!
    var model: GeneralDayModelProtocol!
    var view: GeneralDayViewProtocol!
    
    func updateWeatherData(_ data: ForecastCodable) {
        let dataSource = data.convertToForecast()
        UserDataRepository.shared.saveCityName(name: dataSource.cityName)
        self.view.refreshData(dataSource)
    }
    
}

extension GeneralDayPresenter: GeneralDayPresenterProtocol {
    
    func didGeneralDayScreenLoad() {
        if UserDataRepository.shared.getSavedCoordinates() == nil {
            UserDataRepository.shared.setDefaultData()
        }
        guard let coord = UserDataRepository.shared.getSavedCoordinates() else { return }
        model.updateDataByLocation(lat: coord.lat, lon: coord.lon) { [unowned self] result in
            UserDataRepository.shared.saveCityName(name: result.city.name)
            self.view.refreshData(result.convertToForecast())
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
        if UserDataRepository.shared.getSavedCoordinates() == nil {
            UserDataRepository.shared.setDefaultData()
        }
        guard let coord = UserDataRepository.shared.getSavedCoordinates() else { return }
        model.updateDataByLocation(lat: coord.lat, lon: coord.lon) { [unowned self] result in
            UserDataRepository.shared.saveCityName(name: result.city.name)
            self.view.refreshData(result.convertToForecast())
        }
    }
    
    func showDayDetails(_ dataSource: ForecastDay, cityName: String) {
        router?.showDayDetails(dataSource, cityName: cityName)
    }
    
}
