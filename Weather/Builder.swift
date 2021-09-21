import UIKit

class Builder: BuilderProtocol {
    
    func buildGeneralDayScreen(_ router: GeneralDayRouterProtocol ) -> UIViewController {
        let model = GeneralDayModel()
        let view = UIGeneralDayViewController()
        let presenter = GeneralDayPresenter()
        model.presenter = presenter
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
        model.presenter = presenter
        view.presenter = presenter
        presenter.view = view
        presenter.model = model
        presenter.router = router
        
        return view
    }
    func buildDayDetailsScreen(_ router: AnotherRouterProtocol, dataSource: DataSourceDay ) -> UIViewController {
        let view = UIDayDetailsViewController()
        let presenter = DayDetailsPresenter()
        view.presenter = presenter
        view.dataSource = dataSource
        presenter.view = view
        presenter.router = router
        
        return view
    }
    
}
