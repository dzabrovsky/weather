import Foundation

protocol LaunchRouterProtocol {
    func showGeneralDayView()
}

class LaunchPresenter: LaunchPresenterProtocol {
    
    var router: LaunchRouterProtocol
    
    init(router: LaunchRouterProtocol) {
        self.router = router
    }
    
    func onAnimationsComplete() {
        router.showGeneralDayView()
    }
}
