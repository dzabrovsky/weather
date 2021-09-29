import Foundation

protocol SearchViewProtocol: AnyObject {
    func switchTheme()
    func openAddCityAlert()
    func updateCityList(_ dataSource: CityWeather)
    
    func showAlertCityDoesNotExists()
    func showAlertCityAlreadyExists()
}

protocol SearchRouterProtocol: AnotherRouterProtocol {
    func popToRootWithSelectedCity()
    func showMapView()
}

class SearchPresenter {
    
    var router: SearchRouterProtocol!
    var model: SearchModel!
    var view: SearchViewProtocol!
}

extension SearchPresenter: SearchPresenterProtocol {
    
    func onTapLocationButton() {
        router.showMapView()
    }
    
    func onTapBack() {
        router.popToRoot()
    }
    
    func onTapThemeButton() {
        view.switchTheme()
    }
    
    func onTapAddCity(){
        view.openAddCityAlert()
    }
    
    func updateDataSource() {
        model.updateCityList(){ result in
            self.view.updateCityList(result.convertToCity())
        }
    }
    
    func onRowSelected(_ cityName: String) {
        model.getCityData(cityName){ name, lat, lon in
            UserDataRepository.shared.saveCityName(name: name)
            UserDataRepository.shared.saveCity(lat: lat, lon: lon)
            self.router.popToRootWithSelectedCity()
        }
    }
    
    func inputCityName(_ cityName: String) {
        model.insertCity(cityName){ result, info in
            switch info {
            case .AlreadyExists:
                self.view.showAlertCityAlreadyExists()
            case .NotExists:
                self.view.showAlertCityDoesNotExists()
            case .Succed:
                guard let result = result else{ return }
                self.view.updateCityList(result.convertToCity())
            }
        }
    }
}
