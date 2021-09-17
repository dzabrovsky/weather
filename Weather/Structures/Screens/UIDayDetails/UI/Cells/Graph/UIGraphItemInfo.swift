import UIKit

class UIGraphItemInfo: UIView {

    let tempLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = UIColor.init(named: "black_text")
        label.font = UIFont.init(name: "Manrope-ExtraBold", size: 18)
        label.text = "25°"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    let tempFeelsLikeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = UIColor.init(named: "gray_text")
        label.font = UIFont.init(name: "Manrope-ExtraBold", size: 18)
        label.text = "25°"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "01d")
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    init() {
        super.init(frame: CGRect())
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        addSubview(tempLabel)
        addSubview(tempFeelsLikeLabel)
        addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            tempLabel.leftAnchor.constraint(equalTo: leftAnchor),
            tempLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            tempLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8),
            
            tempFeelsLikeLabel.leftAnchor.constraint(equalTo: tempLabel.rightAnchor),
            tempFeelsLikeLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            tempFeelsLikeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8),
            
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 40 / 75),
            iconImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 40 / 75)
        ])
    }
}
