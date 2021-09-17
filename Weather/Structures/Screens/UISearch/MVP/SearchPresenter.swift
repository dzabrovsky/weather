import Foundation

protocol SearchViewProtocol: AnyObject {
    func switchTheme()
    func openAddCityAlert()
    func updateCityList(_ dataSource: CityListItemDataSourceProtocol)
}

protocol SearchModelProtocol {
    
    func insertCityInCitiesList(name: String)
    func didCityListUpdate()
    func updateCityList()
    func clearCoreData()
    func updateCityLastUse(_ name: String)
    
}

class SearchPresenter {
    
    var router: RouterProtocol?
    var model: SearchModelProtocol!
    var view: SearchViewProtocol!
}

extension SearchPresenter: SearchPresenterProtocol {
    
    func onTapBack() {
        router?.popToRoot()
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
        model.insertCityInCitiesList(name: cityName)
    }
}

extension SearchPresenter: SearchPresenterProtocolForModel {
    
    func cityListUpdated(_ dataSource: CityListItemDataSourceProtocol ){
        view.updateCityList(dataSource)
    }
    
    func didCityLastUseUpdate(_ cityName: String) {
        router?.popToRootWithSelectedCity(cityName)
    }
}
