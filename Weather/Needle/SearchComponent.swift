import Foundation
import NeedleFoundation

protocol SearchDependency: Dependency {
    var alamofireFacade: AlamofireFacadeProtocol { get }
    var coreDataFacade: CoreDataFacadeProtocol { get }
    var userDataRepository: UserDataRepositoryProtocol { get }
}

class SearchComponent: Component<SearchDependency>, SearchBuilder {
    
    var model: SearchModel{
        return SearchModel(alamofireFacade: dependency.alamofireFacade, coreDataFacade: dependency.coreDataFacade)
    }
    
    var presenter: SearchPresenter{
        return SearchPresenter(userDataRepository: dependency.userDataRepository)
    }
    
    var view: UISearchViewController{
        return UISearchViewController()
    }
}

protocol SearchBuilder {
    var model: SearchModel { get }
    var presenter: SearchPresenter { get }
    var view: UISearchViewController { get }
}
