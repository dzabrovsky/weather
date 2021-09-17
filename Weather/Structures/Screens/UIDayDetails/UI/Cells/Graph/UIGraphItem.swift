import UIKit

class UIGraphItem: UICollectionViewCell {
    
    let info: UIGraphItemInfo = {
        let info = UIGraphItemInfo()
        
        return info
    }()
    
    let gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.762, green: 0.821, blue: 0.892, alpha: 0).cgColor,
            UIColor(red: 0.762, green: 0.821, blue: 0.892, alpha: 0.2).cgColor
        ]
        gradient.locations = [0.26, 1]
        gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradient.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        
        return gradient
    }()
    
    let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 43/375, height: UIScreen.main.bounds.width * 218/375 ))
    
    let hourLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.init(named: "gray_text")
        label.font = UIFont.init(name: "Lato-Regular", size: 16)
        label.text = "01:00"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var point: CGPoint = CGPoint()

    func setup() {
        
        self.addSubview(view)
        
        drawGradient()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .black
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        layer.insertSublayer(gradient, at: 0)
        contentView.addSubview(info)
        contentView.addSubview(hourLabel)
        
        NSLayoutConstraint.activate([
            info.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 75/46),
            info.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 75/46),
            info.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: point.y - 13),
            info.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            hourLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            hourLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            hourLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func drawGradient(){
        gradient.bounds = CGRect(x: 0, y: point.y, width: bounds.width, height: bounds.height - point.y)
    }
}
