import UIKit

protocol LaunchPresenterProtocol {
    func onStartLoading()
    func onLoadingComplete()
}

class UILaunchScreen: UIViewController {
    
    private static let k: CGFloat = UIScreen.main.bounds.width / 375
    
    var presenter: LaunchPresenterProtocol!
    
    let head: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(named: "background")
        return view
    }()
    
    let logo: UILabel = {
        let label = UILabel()
        label.text = "weather"
        label.font = UIFont.init(name: "ManRope-ExtraBold", size: 32*k)
        label.textColor = UIColor.init(named: "black_text")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let loader: UIProgressView = {
        let progress = UIProgressView()
        progress.layer.cornerRadius = 8*k/2
        progress.progressViewStyle = .default
        progress.setProgress(0, animated: false)
        progress.progressTintColor = UIColor.init(named: "apply_button_background")
        progress.trackTintColor = UIColor.init(named: "background")
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.alpha = 0
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        showLaunchScreen()
        animateHead()
    }
    
    func showLaunchScreen(){
        presenter.onStartLoading()
        view.backgroundColor = UIColor.init(named: "background")
        view.addSubview(head)
        view.addSubview(logo)
        head.addSubview(loader)
        NSLayoutConstraint.activate([
            head.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            head.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            head.heightAnchor.constraint(equalTo: view.heightAnchor),
            head.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            logo.widthAnchor.constraint(equalTo: view.widthAnchor),
            logo.topAnchor.constraint(equalTo: view.bottomAnchor),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            
            loader.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            loader.heightAnchor.constraint(equalToConstant: 8 * UILaunchScreen.k),
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.topAnchor.constraint(equalTo: head.bottomAnchor, constant: 16 * UILaunchScreen.k)
        ])
    }
    
    func animateHead(){
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
            NSLayoutConstraint.activate([
                self.head.heightAnchor.constraint(equalTo: self.view.widthAnchor),
                self.head.widthAnchor.constraint(equalTo: self.view.widthAnchor)
            ])
            UIView.animate(
                withDuration: 0.4,
                animations: {
                    self.head.backgroundColor = UIColor.init(named: "apply_button_background")
                    self.view.layoutIfNeeded()
                },
                completion: { _ in
                    NSLayoutConstraint.activate([
                        self.head.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2),
                        self.head.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2)
                    ])
                    UIView.animate(
                        withDuration: 0.5,
                        animations: {
                            self.head.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.25)
                            self.view.layoutIfNeeded()
                        },
                        completion: { _ in
                            UIView.animate(
                                withDuration: 0.4,
                                animations: {
                                    self.head.transform = CGAffineTransform(rotationAngle: 0)
                                    self.head.layer.cornerRadius = self.view.bounds.width * 0.2 / 2
                                    self.head.layoutIfNeeded()
                                },
                                completion: { _ in
                                    NSLayoutConstraint.activate([
                                        self.logo.centerYAnchor.constraint(equalTo: self.head.centerYAnchor)
                                    ])
                                    UIView.animate(
                                        withDuration: 0.5,
                                        delay: 0,
                                        usingSpringWithDamping: 0.5,
                                        initialSpringVelocity: 1,
                                        options: .curveEaseInOut,
                                        animations: {
                                            self.view.layoutIfNeeded()
                                        }, completion: { _ in
                                            
                                            UIView.animate(
                                                withDuration: 0.2,
                                                animations: {
                                                    self.loader.alpha = 1
                                                    self.loader.layoutIfNeeded()
                                                },
                                                completion: { _ in
                                                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                                                        self.loader.setProgress(self.loader.progress + 0.05, animated: true)
                                                        if self.loader.progress >= 1 {
                                                            timer.invalidate()
                                                            self.presenter.onLoadingComplete()
                                                        }
                                                    }
                                                }
                                            )
                                        }
                                    )
                                }
                            )
                        }
                    )
                }
            )
        }
    }
    func setup(){
        
    }
}
