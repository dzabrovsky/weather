import Foundation

protocol SearchViewProtocol: AnyObject {
    func switchTheme()
    func openAddCityAlert()
    func updateCityList(_ dataSource: CityDataSource)
    
    func showAlertCityDoesNotExists()
    func showAlertCityAlreadyExists()
}

protocol SearchRouterProtocol: AnotherRouterProtocol {
    func popToRootWithSelectedCity()
}

class SearchPresenter {
    
    var router: SearchRouterProtocol!
    var model: SearchModel!
    var view: SearchViewProtocol!
}

extension SearchPresenter: SearchPresenterProtocol {
    
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
            self.view.updateCityList( result.convertToCity() )
        }
    }
    
    func onRowSelected(_ cityName: String) {
        model.updateCityLastUse(cityName){ name, lat, lon in
            UserDataManager.saveCityName(name: name)
            UserDataManager.saveCity(lat: lat, lon: lon)
            self.router.popToRootWithSelectedCity()
        }
    }
    
    func inputCityName(_ cityName: String) {
        model.checkCity(cityName){ result, info in
            switch info {
            case .AlreadyExists:
                self.view.showAlertCityAlreadyExists()
            case .NotExists:
                self.view.showAlertCityDoesNotExists()
            case .Complete:
                if let result = result {
                    self.view.updateCityList( result.convertToCity() )
                }
            }
        }
    }
}
