import Foundation

protocol LaunchRouterProtocol {
    func showGeneralDayView()
}

class LaunchPresenter: LaunchPresenterProtocol {
    
    var router: LaunchRouterProtocol!
    
    func onAnimationsComplete() {
        router.showGeneralDayView()
    }
}
