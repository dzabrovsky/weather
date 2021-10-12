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
    
    let userDataRepository: UserDataRepositoryProtocol
    
    var currentData: Forecast?
    
    init(userDataRepository: UserDataRepositoryProtocol) {
        self.userDataRepository = userDataRepository
    }
    
    func updateWeatherData(_ data: ForecastCodable) {
        let dataSource = data.convertToForecast()
        UserDataRepository.shared.saveCityName(name: dataSource.cityName)
        self.view.refreshData(dataSource)
    }
    
}

extension GeneralDayPresenter: GeneralDayPresenterProtocol {
    
    func didGeneralDayScreenLoad() {
        if userDataRepository.getSavedCoordinates() == nil {
            userDataRepository.setDefaultData()
        }
        guard let coord = userDataRepository.getSavedCoordinates() else { return }
        model.updateDataByLocation(lat: coord.lat, lon: coord.lon) { [unowned self] result in
            userDataRepository.saveCityName(name: result.city.name)
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
        if userDataRepository.getSavedCoordinates() == nil {
            userDataRepository.setDefaultData()
        }
        guard let coord = userDataRepository.getSavedCoordinates() else { return }
        model.updateDataByLocation(lat: coord.lat, lon: coord.lon) { result in
            userDataRepository.saveCityName(name: result.city.name)
            self.currentData = result.convertToForecast()
            guard let currentData = self.currentData else { return }
            self.view.refreshData(currentData)
        }
    }
    
    func showDayDetails(_ index: Int) {
        guard let currentData = currentData else { return }
        router?.showDayDetails(currentData.forecast[index], cityName: currentData.cityName)
    }
    
}
