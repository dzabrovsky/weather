import UIKit

class UITableViewCellWithWaiter: UITableViewCell {

    var isWaiterActive: Bool = true
    
    var waiterColor = UIColor.init(named: "background") ?? .white {
        didSet{
            setupWaiter()
        }
    }
    var waiterAlphaColor = UIColor.init(named: "cv_cell_background") ?? .white{
        didSet{
            setupWaiter()
        }
    }
    
    var waiterBackgroundColor: UIColor = .white {
        didSet{
            waiterView.backgroundColor = waiterBackgroundColor
        }
    }
    
    private let waiterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(named: "tv_cell_background")
        return view
    }()
    
    private let waiterLayer: CAGradientLayer = {
        let waiterLayer = CAGradientLayer()
        waiterLayer.startPoint = CGPoint(x: 0, y: 0)
        waiterLayer.endPoint = CGPoint(x: 1, y: 0.1)
        waiterLayer.locations = [0,0.1,0.2]
        return waiterLayer
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWaiterView()
        setupWaiter()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWaiterView(){
        addSubview(waiterView)
        waiterView.layer.addSublayer(waiterLayer)
        waiterView.layer.masksToBounds = true
    }
    
    private func setupWaiter() {
        waiterLayer.colors = [ waiterAlphaColor.cgColor, waiterColor.cgColor, waiterAlphaColor.cgColor]
    }
    
    private func getAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0,0.1,0.2]
        animation.toValue = [0.8,0.9,1]
        animation.duration = 0.7
        animation.repeatCount = .infinity
        return animation
    }
    
    func drawWaiter(bounds: CGRect, cornerRadius: CGFloat){
        waiterView.frame = bounds
        waiterView.layer.cornerRadius = cornerRadius
        waiterLayer.frame = CGRect(x: -bounds.width/2, y: 0, width: bounds.width*2, height: bounds.height)
        waiterLayer.add(getAnimation(), forKey: "locations")
        bringSubviewToFront(waiterView)
    }
    
    func hideWaiter(){
        waiterView.isHidden = true
    }
}
