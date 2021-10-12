import UIKit

protocol LaunchPresenterProtocol {
    func onAnimationsComplete()
}

class UILaunchScreen: UIViewController {
    
    var presenter: LaunchPresenterProtocol!
    
    let launchView: UILaunchView = UILaunchView()
    
    init(presenter: LaunchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

