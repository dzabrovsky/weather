import Foundation

protocol SearchViewProtocol: AnyObject {
    func switchTheme()
    func openAddCityAlert()
    func updateCityList(_ dataSource: CityListItemDataSourceProtocol)
    
    func showAlertCityDoesNotExists()
    func showAlertCityAlreadyExists()
}

protocol SearchModelProtocol {
    
    func didCityListUpdate()
    func updateCityList()
    func clearCoreData()
    func updateCityLastUse(_ name: String)
    
    func checkCity(_ name: String)
    
}

protocol SearchRouterProtocol: AnotherRouterProtocol {
    func popToRootWithSelectedCity(_ cityName: String)
}

class SearchPresenter {
    
    var router: SearchRouterProtocol!
    var model: SearchModelProtocol!
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
        model.updateCityList()
    }
    
    func onRowSelected(_ cityName: String) {
        model.updateCityLastUse(cityName)
    }
    
    func inputCityName(_ cityName: String) {
        model.checkCity(cityName)
    }
}

extension SearchPresenter: SearchPresenterProtocolForModel {
    
    func cityAlreadyExists() {
        view.showAlertCityAlreadyExists()
    }
    
    func cityDoesNotExists() {
        view.showAlertCityDoesNotExists()
    }
    
    
    func cityListUpdated(_ dataSource: CityListItemDataSourceProtocol ){
        view.updateCityList(dataSource)
    }
    
    func didCityLastUseUpdate(_ cityName: String) {
        router.popToRootWithSelectedCity(cityName)
    }
}
