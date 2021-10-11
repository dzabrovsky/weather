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
    
    var currentData: Forecast?
    
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
            currentData = result.convertToForecast()
            guard let currentData = currentData else { return }
            self.view.refreshData(currentData)
        }
    }
    
    func showDayDetails(_ index: Int) {
        guard let currentData = currentData else { return }
        router?.showDayDetails(currentData.forecast[index], cityName: currentData.cityName)
    }
    
}
