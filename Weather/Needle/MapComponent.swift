import Foundation
import NeedleFoundation

protocol MapDependency: Dependency {
    var alamofireFacade: AlamofireFacadeProtocol { get }
    var coreDataFacade: CoreDataFacadeProtocol { get }
    var userDataRepository: UserDataRepositoryProtocol { get }
    var locationManagerFacade: LocationManagerFacadeProtocol { get }
}

class MapComponent: Component<MapDependency>, MapBuilder {
    
    var model: MapModel{
        return MapModel(alamofireFacade: dependency.alamofireFacade, coreDataFacade: dependency.coreDataFacade, locationManagerFacade: dependency.locationManagerFacade)
    }
    
    var presenter: MapPresenter{
        return MapPresenter(userDataRepository: dependency.userDataRepository)
    }
    
    var view: UIMapViewController{
        return UIMapViewController()
    }
}

protocol MapBuilder {
    var model: MapModel { get }
    var presenter: MapPresenter { get }
    var view: UIMapViewController { get }
}
