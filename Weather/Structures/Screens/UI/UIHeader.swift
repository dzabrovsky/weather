import UIKit

enum HeaderSide {
    case left
    case right
}

struct HeaderButton {
    let icon: UIImage
    let side: HeaderSide
    let handler: HeaderButtonHandler
}

typealias HeaderButtonHandler = () -> Void

protocol UIHeaderDelegate {
    func buttonsForHeader() -> [HeaderButton]?
}

class UIHeader: UIView {
    
    var delegate: UIHeaderDelegate? {
        didSet{
            guard let delegate = delegate else { return }
            guard let buttons = delegate.buttonsForHeader() else { return }
            for button in buttons {
                self.addButton(button)
            }
        }
    }
    
    let title: UILabelWithWaiter = {
        let label = UILabelWithWaiter()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont.init(name: "Manrope-ExtraBold", size: 18 * screenScale)
        label.textColor = UIColor.init(named: "black_text")
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var leftButtons = [UIHeaderButton]()
    private var rightButtons = [UIHeaderButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        
        backgroundColor = UIColor.init(named: "background")
        translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(title)
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 30/64),
            title.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3)
        ])
    }
    
    private func addButton(_ headerButton: HeaderButton) {
        let button = UIHeaderButton(4 * screenScale, side: headerButton.side, handler: headerButton.handler)
        button.icon.image = headerButton.icon
        button.layer.cornerRadius = 8 * screenScale
        button.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            button.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ])
        
        switch headerButton.side {
        case .left:
            if leftButtons.count > 0 {
                guard let lastButton = leftButtons.last else { return }
                button.leftAnchor.constraint(equalTo: lastButton.rightAnchor, constant: 8 * screenScale).isActive = true
            }else{
                button.leftAnchor.constraint(equalTo: leftAnchor, constant: 16 * screenScale).isActive = true
            }
            leftButtons.append(button)
        case .right:
            if rightButtons.count > 0 {
                guard let lastButton = rightButtons.last else { return }
                button.rightAnchor.constraint(equalTo: lastButton.leftAnchor, constant: -8 * screenScale).isActive = true
            }else{
                button.rightAnchor.constraint(equalTo: rightAnchor, constant: -16 * screenScale).isActive = true
            }
            rightButtons.append(button)
        }
    }
}
