import UIKit

class UILabelWithWaiter: UILabel {
    
    private let waiterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(named: "tv_cell_background")
        return view
    }()
    
    private let waiterLayer: CAGradientLayer = {
        let waiterLayer = CAGradientLayer()
        let color = UIColor.init(named: "background") ?? .white
        let alphaColor = UIColor.init(named: "cv_cell_background") ?? .white
        waiterLayer.colors = [ alphaColor.cgColor, color.cgColor, alphaColor.cgColor]
        waiterLayer.startPoint = CGPoint(x: 0, y: 0)
        waiterLayer.endPoint = CGPoint(x: 1, y: 0.1)
        waiterLayer.locations = [0,0.1,0.2]
        return waiterLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        waiterView.layer.addSublayer(waiterLayer)
        waiterView.layer.masksToBounds = true
        addSubview(waiterView)
    }
    
    private func getAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0,0.1,0.2]
        animation.toValue = [0.8,0.9,1]
        animation.duration = 0.7
        animation.repeatCount = .infinity
        return animation
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect)
        if text == nil {
            waiterView.isHidden = false
            waiterView.frame = CGRect(x: -bounds.height/4, y: 0, width: bounds.width + bounds.height/2, height: bounds.height)
            waiterLayer.frame = CGRect(x: -bounds.width/2, y: 0, width: bounds.width*2, height: bounds.height)
            waiterLayer.cornerRadius = waiterView.bounds.height/2
            waiterView.layer.cornerRadius = waiterLayer.cornerRadius
            waiterLayer.add(getAnimation(), forKey: "locations")
        }else{
            waiterView.isHidden = true
        }
    }
}
