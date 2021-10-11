import UIKit

class Builder: BuilderProtocol {
    
    func buildNavigationController() -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        let router = Router(navigationController: navigationController, builder: self)
        router.showLaunchScreen()
        return navigationController
    }
    
    func buildLaunchScreen(_ router: LaunchRouterProtocol) -> UIViewController {
        let view = UILaunchScreen()
        let presenter = LaunchPresenter()
        presenter.router = router
        view.presenter = presenter
        return view
    }
    
    func buildGeneralDayScreen(_ router: GeneralDayRouterProtocol ) -> UIViewController {
        let model = GeneralDayModel()
        let view = UIGeneralDayViewController()
        let presenter = GeneralDayPresenter()
        presenter.view = view
        presenter.model = model
        presenter.router = router
        view.setPresenter(presenter)
        
        return view
    }
    func buildSearchScreen(_ router: SearchRouterProtocol ) -> UIViewController {
        let model = SearchModel()
        let view = UISearchViewController()
        let presenter = SearchPresenter()
        view.presenter = presenter
        presenter.view = view
        presenter.model = model
        presenter.router = router
        
        return view
    }
    func buildDayDetailsScreen(_ router: DayDetailsRourerProtocol, dataSource: ForecastDay, cityName: String ) -> UIViewController {
        let view = UIDayDetailsViewController()
        let presenter = DayDetailsPresenter()
        view.cityName = cityName
        view.presenter = presenter
        view.dataSource = dataSource
        presenter.view = view
        presenter.router = router
        
        return view
    }
    func buildMapScreen(_ router: MapRouterProtocol) -> UIViewController{
        let view = UIMapViewController()
        let model = MapModel()
        let presenter = MapPresenter(router: router, model: model)
        presenter.view = view
        view.presenter = presenter
        
        return view
    }
}
