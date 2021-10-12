import UIKit

protocol BuilderProtocol {
    func buildLaunchScreen(_ router: LaunchRouterProtocol) -> UIViewController
    func buildGeneralDayScreen(_ router: GeneralDayRouterProtocol ) -> UIViewController
    func buildSearchScreen(_ router: SearchRouterProtocol ) -> UIViewController
    func buildDayDetailsScreen(_ router: DayDetailsRourerProtocol, dataSource: ForecastDay, cityName: String) -> UIViewController
    func buildMapScreen(_ router: MapRouterProtocol) -> UIViewController
}

protocol AnotherRouterProtocol {
    func popToRoot()
}

protocol RouterProtocol: GeneralDayRouterProtocol, SearchRouterProtocol, MapRouterProtocol, DayDetailsRourerProtocol, LaunchRouterProtocol {
    func showLaunchScreen()
}

class Router: RouterProtocol {
    
    private let navigationController: UINavigationController
    private let builder: BuilderProtocol
    init(navigationController: UINavigationController, builder: BuilderProtocol) {
        self.builder = builder
        self.navigationController = navigationController
    }
    
    func showGeneralDayView(){
        let generalDayView = builder.buildGeneralDayScreen(self)
        navigationController.viewControllers = [generalDayView]
    }
    
    func showLaunchScreen() {
        let launchViewController = builder.buildLaunchScreen(self) as! UILaunchScreen
        navigationController.pushViewController(launchViewController, animated: true)
    }
    
    func showSearchView() {
        let searchViewController = builder.buildSearchScreen(self)
        navigationController.pushViewController(searchViewController, animated: true)
    }
    
    func showDayDetails(_ dataSource: ForecastDay, cityName: String) {
        let searchViewController = builder.buildDayDetailsScreen(self, dataSource: dataSource, cityName: cityName)
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
