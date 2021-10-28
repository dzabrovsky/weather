import Foundation
import NeedleFoundation

protocol GeneralDayDependency: Dependency {
    var alamofireFacade: AlamofireFacadeProtocol { get }
    var userDataRepository: UserDataRepositoryProtocol { get }
}

class GeneralDayComponent: Component<GeneralDayDependency>, GeneralDayBuilder {
    
    var model: GeneralDayModel{
        return GeneralDayModel(alamofireFacade: dependency.alamofireFacade)
    }
    
    var presenter: GeneralDayPresenter{
        return GeneralDayPresenter(userDataRepository: dependency.userDataRepository)
    }
    
    var view: UIGeneralDayViewController{
        return UIGeneralDayViewController()
    }
}

protocol GeneralDayBuilder {
    var model: GeneralDayModel { get }
    var presenter: GeneralDayPresenter { get }
    var view: UIGeneralDayViewController { get }
}
