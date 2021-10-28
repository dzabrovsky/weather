import UIKit
import NeedleFoundation

class Builder: BuilderProtocol {
    
    let rootComponent: RootComponent = RootComponent()
    var generalDayComponent: GeneralDayBuilder
    var searchComponent: SearchBuilder
    var mapComponent: MapBuilder
    
    init() {
        generalDayComponent = rootComponent.generalDayComponent
        searchComponent = rootComponent.searchComponent
        mapComponent = rootComponent.mapComponent
    }
    
    func buildRouter(_ navigationController: UINavigationController) -> Router {
        let router = Router(navigationController: navigationController, builder: self)
        return router
    }
    
    func buildNavigationController() -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        return navigationController
    }
    
    func buildLaunchScreen(_ router: LaunchRouterProtocol) -> UIViewController {
        let presenter = LaunchPresenter(router: router)
        let view = UILaunchScreen(presenter: presenter)
        view.presenter = presenter
        return view
    }
    
    func buildGeneralDayScreen(_ router: GeneralDayRouterProtocol ) -> UIViewController {
        let model = generalDayComponent.model
        let presenter = generalDayComponent.presenter
        let view = UIGeneralDayViewController()
        view.presenter = presenter
        presenter.view = view
        presenter.model = model
        presenter.router = router
        
        return view
    }
    func buildSearchScreen(_ router: SearchRouterProtocol ) -> UIViewController {
        let model = searchComponent.model
        let view = searchComponent.view
        let presenter = searchComponent.presenter
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
        let model = mapComponent.model
        let presenter = mapComponent.presenter
        let view = mapComponent.view
        view.presenter = presenter
        presenter.view = view
        presenter.model = model
        presenter.router = router
        
        return view
    }
}
