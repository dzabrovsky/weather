import Foundation

protocol SearchViewProtocol: AnyObject {
    func switchTheme()
    func openAddCityAlert()
    func updateCityList(_ dataSource: CityWeather)
    func updateAutoCompletion(_ autoCompletion: SearchResults)
    func reloadCityList()
    
    func showAlertCityDoesNotExists()
    func showAlertCityAlreadyExists()
    
    func showAlertNoConnection()
    func showAlertError()
    
    func deleteRowAt(_ index: Int, isToLeft: Bool)
}

protocol SearchRouterProtocol: AnotherRouterProtocol {
    func popToRootWithSelectedCity()
    func showMapView()
}

protocol SearchModelProtocol {
    func searchCity(_ byName: String, completion: @escaping (SearchGeoNames) -> (), error: @escaping (AlamofireStatus) -> ())
    func updateCityList(completion: @escaping (CityListItem, Int) -> Void, error: @escaping (AlamofireStatus) -> Void)
    func getCityData(_ name: String, completion: @escaping (String, Double, Double) -> (), error: @escaping (AlamofireStatus) -> Void)
    func insertCity(_ name: String, completion: @escaping (CityListItem?, CheckResult) -> Void, error: @escaping (AlamofireStatus) -> Void)
    func deleteCity(_ index: Int, completion: @escaping () -> ())
    func swapCitiesInList(at source: Int, to destination: Int)
}

class SearchPresenter {
    
    private var data: [CityWeather] = []
    
    var router: SearchRouterProtocol!
    var model: SearchModelProtocol!
    var view: SearchViewProtocol!
}

extension SearchPresenter: SearchPresenterProtocol {
    func onAlertTextChanged(_ text: String?) {
        guard let text = text else { return }
        guard text.count >= 3 else {
            self.view.updateAutoCompletion(SearchResults(totalResults: 0, results: []))
            return
        }
        model.searchCity(
            text,
            completion: { result in
                self.view.updateAutoCompletion(result.convertToStringArray())
            },
            error: { result in
                switch result{
                case .error:
                    self.view.showAlertError()
                case .noNetwork:
                    self.view.showAlertNoConnection()
                default:
                    self.view.showAlertError()
                }
            }
        )
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
        model.updateCityList(
            completion: { result, count in
                results.append(result.convertToCity())
                print(results.count)
                if results.count == count {
                    for item in results.sorted(by: { $0.index < $1.index} ) {
                        self.data.append(item)
                        self.view.updateCityList(item)
                    }
                }
            },
            error: { result in
                switch result{
                case .error:
                    self.view.showAlertError()
                case .noNetwork:
                    self.view.showAlertNoConnection()
                default:
                    self.view.showAlertError()
                }
            }
        )
    }
    
    func onRowSelected(_ index: Int) {
        model.getCityData(
            data[index].name,
            completion: { name, lat, lon in
                UserDataRepository.shared.saveCityName(name: name)
                UserDataRepository.shared.saveCity(lat: lat, lon: lon)
                self.router.popToRootWithSelectedCity()
            },
            error: { result in
                switch result{
                case .error:
                    self.view.showAlertError()
                case .noNetwork:
                    self.view.showAlertNoConnection()
                default:
                    self.view.showAlertError()
                }
            }
        )
    }
    
    func inputCityName(_ cityName: String) {
        model.insertCity(
            cityName,
            completion: { result, info in
                switch info {
                case .AlreadyExists:
                    self.view.showAlertCityAlreadyExists()
                case .NotExists:
                    self.view.showAlertCityDoesNotExists()
                case .Succed:
                    self.view.reloadCityList()
                }
            },
            error: { result in
                switch result{
                case .error:
                    self.view.showAlertError()
                case .noNetwork:
                    self.view.showAlertNoConnection()
                default:
                    self.view.showAlertError()
                }
            }
        )
    }
    
    func onDeleteRow(_ index: Int, row: Int, isToLeft: Bool) {
        model.deleteCity(index) {
            self.view.deleteRowAt(row, isToLeft: isToLeft)
        }
    }
    
    func onMoveRow(at source: Int, to destination: Int) {
        model.swapCitiesInList(at: data[source].index, to: data[destination].index)
    }
}
