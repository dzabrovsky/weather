import Foundation

protocol SearchViewProtocol: AnyObject {
    func switchTheme()
    func openAddCityAlert()
    func updateCityList(_ dataSource: CityWeather)
    func updateAutoCompletion(_ autoCompletion: SearchResults)
    func reloadCityList()
    
    func showAlertCityDoesNotExists()
    func showAlertCityAlreadyExists()
    
    func deleteRowAt(_ index: Int, isToLeft: Bool)
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
    func onAlertTextChanged(_ text: String?) {
        guard let text = text else { return }
        guard text.count >= 3 else {
            self.view.updateAutoCompletion(SearchResults(totalResults: 0, results: []))
            return
        }
        model.searchCity(text) { result in
            self.view.updateAutoCompletion(result.convertToStringArray())
        }
    }
    
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
        var results = [CityWeather]()
        model.updateCityList(){ result, count in
            results.append(result.convertToCity())
            print(results.count)
            if results.count == count {
                for item in results.sorted(by: { $0.index < $1.index} ) {
                    self.view.updateCityList(item)
                }
            }
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
                self.view.reloadCityList()
            }
        }
    }
    
    func onDeleteRow(_ index: Int, row: Int, isToLeft: Bool) {
        model.deleteCity(index) {
            self.view.deleteRowAt(row, isToLeft: isToLeft)
        }
    }
    
    func onMoveRow(source: Int, destination: Int) {
        model.swapCitiesInList(source: source, destination: destination)
    }
}
