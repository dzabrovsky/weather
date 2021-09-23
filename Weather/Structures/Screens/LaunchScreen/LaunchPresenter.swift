import Foundation

protocol LaunchRouterProtocol {
    func initialGeneralDayView()
    func showGeneralDayView()
}

class LaunchPresenter: LaunchPresenterProtocol {
    
    var router: LaunchRouterProtocol!
    func onStartLoading() {
        router.initialGeneralDayView()
    }
    
    func onLoadingComplete() {
        router.showGeneralDayView()
    }
}
