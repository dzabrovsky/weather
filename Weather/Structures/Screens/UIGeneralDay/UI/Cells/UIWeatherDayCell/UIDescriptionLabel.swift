import UIKit

class UIDescriptionLabel: UILabel {
    
    init() {
        super.init(frame: CGRect())
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont.init(name: "Manrope-Medium", size: 14 * screenScale)
        self.textAlignment = .center
        self.textColor = .white
    }
}
