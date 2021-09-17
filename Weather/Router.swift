import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var builder: BuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialGeneralDayView()
    func showSearchView()
    func showDayDetails(_ dataSource: DataSourceDay)
    func popToRoot()
    func popToRootWithSelectedCity(_ cityName: String)
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var builder: BuilderProtocol?
    
    func initialGeneralDayView() {
        if let navigationController = navigationController {
            guard let mainViewController = builder?.buildGeneralDayScreen(self) else {
                return
            }
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func showSearchView() {
        if let navigationController = navigationController {
            guard let searchViewController = builder?.buildSearchScreen(self) else {
                return
            }
            navigationController.pushViewController(searchViewController, animated: true)
        }
    }
    
    func showDayDetails(_ dataSource: DataSourceDay) {
        if let navigationController = navigationController {
            guard let searchViewController = builder?.buildDayDetailsScreen(self, dataSource: dataSource) else {
                return
            }
            navigationController.pushViewController(searchViewController, animated: true)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func popToRootWithSelectedCity(_ cityName: String) {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
            let generalDay = navigationController.viewControllers[0] as! UIGeneralDayViewController
            generalDay.presenter.onApplyNewCityName(cityName)
        }
    }
    
    init(navigationController: UINavigationController, builder: BuilderProtocol) {
        self.builder = builder
        self.navigationController = navigationController
    }
    
}
