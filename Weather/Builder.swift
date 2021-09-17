import UIKit

protocol BuilderProtocol {
    func buildGeneralDayScreen(_ router: RouterProtocol ) -> UIViewController
    func buildSearchScreen(_ router: RouterProtocol ) -> UIViewController
    func buildDayDetailsScreen(_ router: RouterProtocol, dataSource: DataSourceDay ) -> UIViewController
}

class Builder: BuilderProtocol {
    
    func buildGeneralDayScreen(_ router: RouterProtocol ) -> UIViewController {
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
    func buildSearchScreen(_ router: RouterProtocol ) -> UIViewController {
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
    func buildDayDetailsScreen(_ router: RouterProtocol, dataSource: DataSourceDay ) -> UIViewController {
        let view = UIDayDetailsViewController()
        let presenter = DayDetailsPresenter()
        view.presenter = presenter
        view.dataSource = dataSource
        presenter.view = view
        presenter.router = router
        
        return view
    }
    
}
