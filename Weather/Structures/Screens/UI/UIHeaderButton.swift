import UIKit

public class UIHeaderButton: UIButton{
    
    let icon: UIImageView = UIImageView()
    let side: HeaderSide
    private var padding: CGFloat = 0
    
    private let handler: HeaderButtonHandler?
    
    init(_ value: CGFloat, side: HeaderSide, handler: HeaderButtonHandler? = nil) {
        self.padding = value
        self.handler = handler
        self.side = side
        super.init(frame: CGRect())
        
        setup()
        layout()
        setPaddings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onTap(){
        guard let handler = handler else { return }
        handler()
    }
    
    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tapGesture)
    }
    
    private func setPaddings(){
        
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalTo: widthAnchor, constant: -padding*2),
            icon.heightAnchor.constraint(equalTo: heightAnchor, constant: -padding*2),
            
            icon.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            icon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            icon.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
            icon.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding)
        ])
    }
    
    private func layout(){

        backgroundColor = UIColor.init(named: "icon_background")
        addSubview(icon)
        
        icon.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        icon.tintColor = UIColor.init(named: "icon_tint")
        icon.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
