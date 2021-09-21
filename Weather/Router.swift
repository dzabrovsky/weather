import UIKit

protocol BuilderProtocol {
    func buildGeneralDayScreen(_ router: GeneralDayRouterProtocol ) -> UIViewController
    func buildSearchScreen(_ router: SearchRouterProtocol ) -> UIViewController
    func buildDayDetailsScreen(_ router: AnotherRouterProtocol, dataSource: DataSourceDay ) -> UIViewController
    func buildMapScreen(_ router: MapRouterProtocol) -> UIViewController
}

protocol AnotherRouterProtocol {
    func popToRoot()
}

protocol RouterProtocol: GeneralDayRouterProtocol, SearchRouterProtocol, MapRouterProtocol {
    func initialGeneralDayView()
}

class Router: RouterProtocol {
    
    private let navigationController: UINavigationController
    private let builder: BuilderProtocol
    
    init(navigationController: UINavigationController, builder: BuilderProtocol) {
        self.builder = builder
        self.navigationController = navigationController
    }
    
    func initialGeneralDayView() {
        let mainViewController = builder.buildGeneralDayScreen(self)
        navigationController.viewControllers = [mainViewController]
    }
    
    func showSearchView() {
        let searchViewController = builder.buildSearchScreen(self)
        navigationController.pushViewController(searchViewController, animated: true)
    }
    
    func showDayDetails(_ dataSource: DataSourceDay) {
        let searchViewController = builder.buildDayDetailsScreen(self, dataSource: dataSource)
        navigationController.pushViewController(searchViewController, animated: true)
    }
    func showMapView(){
        let mapViewController = builder.buildMapScreen(self)
        navigationController.pushViewController(mapViewController, animated: true)
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func popToRootWithSelectedCity() {
        let generalDay = navigationController.viewControllers[0] as! UIGeneralDayViewController
        navigationController.popToRootViewController(animated: true)
        generalDay.presenter.didGeneralDayScreenLoad()
    }
    
}
