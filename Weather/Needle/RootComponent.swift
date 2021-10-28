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
}
