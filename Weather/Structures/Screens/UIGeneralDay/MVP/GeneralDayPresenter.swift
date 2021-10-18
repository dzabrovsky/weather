import Foundation

protocol GeneralDayViewProtocol: AnyObject {
    
    func refreshData(_ dataSource: Forecast)
    func updateCityName(_ name: String)
    func switchTheme()
    
    func showAlertNoConnection()
    func showAlertError()
    
}

protocol GeneralDayRouterProtocol {
    func showDayDetails(_ dataSource: ForecastDay, cityName: String)
    func showSearchView()
    func showMapView()
}

protocol GeneralDayModelProtocol {
    func updateDataByLocation(lat: Double, lon: Double, completion: @escaping (ForecastCodable) -> Void, error: @escaping (AlamofireStatus) -> Void)
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
        updateDataByUser()
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
        guard let coord = userDataRepository.getSavedCoordinates() else { return }
        model.updateDataByLocation(
            lat: coord.lat,
            lon: coord.lon,
            completion: { result in
                self.userDataRepository.saveCityName(name: result.city.name)
                self.currentData = result.convertToForecast()
                guard let currentData = self.currentData else { return }
                self.view.refreshData(currentData)
                self.view.updateCityName(currentData.cityName)
            },
            error: { error in
                self.view.showAlertNoConnection()
            }
        )
    }
    
    func showDayDetails(_ index: Int) {
        guard let currentData = currentData else { return }
        router?.showDayDetails(currentData.forecast[index], cityName: currentData.cityName)
    }
    
}
