import UIKit

class UIErrorAlertView: UIView {
    
    private let container: UIErrorAlertContainer = UIErrorAlertContainer()
    
    init(){
        super.init(frame: CGRect())
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        backgroundColor = UIColor.init(named: "background_alert")
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 343/375),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setTitle(_ title: String){
        container.title.text = title
    }
    
    func setMessage(_ message: String){
        container.message.text = message
    }
    
    func setHandler(handler: @escaping () -> ()){
        container.handler = handler
    }
}
