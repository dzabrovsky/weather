import Foundation

protocol UIDayDetailsViewControllerProtocol: AnyObject {
    func updateView()
    func switchtheme()
}

class DayDetailsPresenter: DayDetailsPresenterProtocol {

    unowned var view: UIDayDetailsViewControllerProtocol!
    var model: GeneralDayModelProtocol!
    var router: AnotherRouterProtocol!
    
    func onTapBackButton() {
        router.popToRoot()
    }
    
    func onTapThemeButton() {
        view.switchtheme()
    }
    
    func onTapCityListButton() {
        
    }
    
    func refreshData() {
        
    }
}
