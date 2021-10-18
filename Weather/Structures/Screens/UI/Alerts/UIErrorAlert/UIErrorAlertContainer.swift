import UIKit

class UIErrorAlertContainer: UIView {
    
    var title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.init(named: "black_text")
        label.backgroundColor = .clear
        label.font = UIFont.init(name: "Manrope-ExtraBold", size: 18 * screenScale)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var message: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = .max
        label.textColor = UIColor.init(named: "black_text")
        label.backgroundColor = .clear
        label.font = UIFont.init(name: "Manrope-Medium", size: 14 * screenScale)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var accept: UIButton = {
        let button = UIButton()
        button.setTitle("Ок", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Manrope-ExtraBold", size: 16 * screenScale)
        button.setTitleColor(UIColor.init(named: "cancel_button_text"), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = UIColor.init(named: "cancel_button_background")
        button.layer.cornerRadius = 12 * screenScale
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var handler: (() -> ())?
    
    init() {
        super.init(frame: CGRect())
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onTapAccept(){
        guard let handler = handler else { return }
        handler()
    }
    
    private func setup() {
        backgroundColor = UIColor.init(named: "background")
        layer.cornerRadius = 24 * screenScale
        addSubviews([title, message, accept])
        
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.topAnchor.constraint(equalTo: topAnchor, constant: 8 * screenScale),
            
            message.centerXAnchor.constraint(equalTo: centerXAnchor),
            message.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16 * screenScale),
            message.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 311/343),
            
            accept.centerXAnchor.constraint(equalTo: centerXAnchor),
            accept.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8 * screenScale),
            accept.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 16 * screenScale),
            accept.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 151/343),
            accept.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 40/343)
        ])
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapAccept))
        accept.addGestureRecognizer(tapGesture)
    }
    
}
