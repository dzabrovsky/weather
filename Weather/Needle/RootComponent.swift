import Foundation
import NeedleFoundation

class RootComponent: BootstrapComponent {
    
    var alamofireFacade: AlamofireFacadeProtocol {
        return AlamofireFacade.shared
    }
    
    var coreDataFacade: CoreDataFacadeProtocol {
        return CoreDataFacade.shared
    }
    
    var locationManagerFacade: LocationManagerFacadeProtocol {
        return LocationManagerFacade.shared
    }
    
    var userDataRepository: UserDataRepositoryProtocol {
        return UserDataRepository.shared
    }
    
    var generalDayComponent: GeneralDayComponent{
        return GeneralDayComponent(parent: self)
    }
    
    var searchComponent: SearchComponent{
        return SearchComponent(parent: self)
    }
    
    var mapComponent: MapComponent{
        return MapComponent(parent: self)
    }
}
