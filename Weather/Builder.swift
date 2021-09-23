import UIKit

class Builder: BuilderProtocol {
    
    func buildGeneralDayScreen(_ router: GeneralDayRouterProtocol ) -> UIViewController {
        let model = GeneralDayModel()
        let view = UIGeneralDayViewController()
        let presenter = GeneralDayPresenter()
        view.presenter = presenter
        presenter.view = view
        presenter.model = model
        presenter.router = router
        
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
    func buildDayDetailsScreen(_ router: AnotherRouterProtocol, dataSource: ForecastDayDataSource ) -> UIViewController {
        let view = UIDayDetailsViewController()
        let presenter = DayDetailsPresenter()
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
        model.delegate = presenter
        
        return view
    }
}
