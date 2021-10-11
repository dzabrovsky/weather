import UIKit

fileprivate let k: CGFloat = UIScreen.main.bounds.width / 375

class UILaunchView: UIView {
    
    var onAnimationComplete: (() -> Void)?
    
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
    
    let gradient: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.type = .radial
        layer.colors=[ UIColor(red: 255/255, green: 226/255, blue: 0, alpha: 0.8).cgColor, UIColor(red: 255/255, green: 226/255, blue: 0, alpha: 0).cgColor]
        layer.startPoint=CGPoint(x: 0.76, y: 0.6)
        layer.endPoint=CGPoint(x: 0.05, y: 0.05)
        layer.locations=[0,1]
        return layer
    }()
    
    func showLaunchScreen(){
        backgroundColor = UIColor.init(named: "background")
        addSubview(head)
        addSubview(logo)
        NSLayoutConstraint.activate([
            head.centerXAnchor.constraint(equalTo: centerXAnchor),
            head.centerYAnchor.constraint(equalTo: centerYAnchor),
            head.heightAnchor.constraint(equalTo: heightAnchor),
            head.widthAnchor.constraint(equalTo: widthAnchor),
            
            logo.widthAnchor.constraint(equalTo: widthAnchor),
            logo.topAnchor.constraint(equalTo: bottomAnchor),
            logo.centerXAnchor.constraint(equalTo: centerXAnchor),
            logo.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
        ])
    }
    
    func animateStepOne() {
        NSLayoutConstraint.activate([
            self.head.heightAnchor.constraint(equalTo: self.widthAnchor),
            self.head.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
        UIView.animate(
            withDuration: 0.4,
            animations: {
                self.head.backgroundColor = UIColor(red: 1, green: 0.741, blue: 0.075, alpha: 1)
                self.layoutIfNeeded()
            },
            completion: { _ in self.animateStepThree() }
        )
    }
    
    func animateStepThree() {
        
        NSLayoutConstraint.activate([
            self.head.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            self.head.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2)
        ])
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.head.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.25)
                self.layoutIfNeeded()
            },
            completion: { _ in self.animateStepFour() }
        )
    }
    
    func animateStepFour() {
        
        NSLayoutConstraint.activate([
            self.head.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            self.head.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2)
        ])
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.head.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.25)
                self.head.layoutIfNeeded()
            },
            completion: { _ in self.animateStepFive()}
        )
    }
    
    func animateStepFive() {
        self.head.layer.addSublayer(self.gradient)
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.head.layoutIfNeeded()
            },
            completion: { _ in self.animateStepSix() }
        )
    }
    
    func animateStepSix() {
        let size = UIScreen.main.bounds.width * 0.2
        self.gradient.frame = CGRect(x: 0, y: 0, width: size, height: size)
        self.gradient.cornerRadius = size/2
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.head.transform = CGAffineTransform(rotationAngle: 0)
                self.head.layer.cornerRadius = self.bounds.width * 0.2 / 2
                self.head.layer.layoutIfNeeded()
            },
            completion: { _ in self.animateStepSeven() }
        )
    }
    
    func animateStepSeven() {
        NSLayoutConstraint.activate([
            self.logo.centerYAnchor.constraint(equalTo: self.head.centerYAnchor)
        ])
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1,
            options: .curveEaseInOut,
            animations: {
                self.layoutIfNeeded()
            },
            completion: { _ in
                guard let onAnimationComplete = self.onAnimationComplete else { return }
                onAnimationComplete()
            }
        )
    }
    
    func startAnimations(completion: @escaping () -> Void){
        self.onAnimationComplete = completion
        self.animateStepOne()
    }
    
}
