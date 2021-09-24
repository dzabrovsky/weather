import Foundation

protocol UIDayDetailsViewControllerProtocol: AnyObject {
    func updateView()
    func switchtheme()
}

protocol DayDetailsRourerProtocol: AnotherRouterProtocol {
    func showSearchView()
}

class DayDetailsPresenter: DayDetailsPresenterProtocol {

    unowned var view: UIDayDetailsViewControllerProtocol!
    var router: DayDetailsRourerProtocol!
    
    func onTapBackButton() {
        router.popToRoot()
    }
    
    func onTapThemeButton() {
        view.switchtheme()
    }
    
    func onTapCityListButton() {
        router.showSearchView()
    }
    
    func onViewDidLoad() {
        view.updateView()
    }
}
