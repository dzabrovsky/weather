import UIKit

protocol LaunchPresenterProtocol {
    func onAnimationsComplete()
}

class UILaunchScreen: UIViewController {
    
    var presenter: LaunchPresenterProtocol!
    
    let launchView: UILaunchView = UILaunchView()
    
    override func viewDidLoad() {
        self.modalPresentationStyle = .fullScreen
        self.modalTransitionStyle = .crossDissolve
        super.viewDidLoad()
    
        setup()
    }
    
    private func setup(){
        view = launchView
        launchView.showLaunchScreen()
        launchView.startAnimations {
            self.presenter.onAnimationsComplete()
        }
    }
}

