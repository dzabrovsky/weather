import UIKit

class UICustomAlert: UIView {
    
    private static let k: CGFloat = UIScreen.main.bounds.width / 375
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = UIFont(name: "Manrope-ExtraBold", size: 14 * k)
        button.setTitleColor(UIColor.init(named: "cancel_button_text"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(named: "cancel_button_background")
        button.layer.cornerRadius = 12 * k
        
        return button
    }()
    
    let applyButton:UIButton = {
        let button = UIButton()
        button.setTitle("Подтвердить", for: .normal)
        button.titleLabel?.font = UIFont(name: "Manrope-ExtraBold", size: 14 * k)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(named: "apply_button_background")
        button.layer.cornerRadius = 12 * k
        
        return button
    }()
    
    let inputCityName: UICustomTextField = {
        let textField = UICustomTextField()
        textField.backgroundColor = UIColor.init(named: "text_input")
        textField.textColor = UIColor.init(named: "black_text")
        textField.layer.cornerRadius = 12 * k
        textField.font = UIFont(name: "Manrope-Medium", size: 14 * k)
        textField.layer.borderColor = UIColor.init(named: "border")?.cgColor
        textField.layer.borderWidth = 1 * k
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let citiesCollectionView: UICustomAlertCollectionView = {
        let collectionView = UICustomAlertCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    init() {
        super.init(frame: CGRect())
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        
        backgroundColor = UIColor.init(named: "background")
        layer.cornerRadius = 24 * UICustomAlert.k
        
        addSubview(cancelButton)
        addSubview(applyButton)
        addSubview(inputCityName)
        addSubview(citiesCollectionView)
        
        NSLayoutConstraint.activate([
            
            inputCityName.centerXAnchor.constraint(equalTo: centerXAnchor),
            inputCityName.topAnchor.constraint(equalTo: topAnchor, constant: 16 * UICustomAlert.k),
            inputCityName.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 40/343),
            inputCityName.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 311/343),
            
            citiesCollectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            citiesCollectionView.topAnchor.constraint(equalTo: inputCityName.bottomAnchor, constant: 12 * UICustomAlert.k),
            citiesCollectionView.heightAnchor.constraint(equalTo: inputCityName.heightAnchor, multiplier: 0.8),
            citiesCollectionView.widthAnchor.constraint(equalTo: widthAnchor),
            
            cancelButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16 * UICustomAlert.k),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16 * UICustomAlert.k),
            cancelButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/4.5),
            cancelButton.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 151/180),
            
            applyButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16 * UICustomAlert.k),
            applyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16 * UICustomAlert.k),
            applyButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            applyButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor)
            
        ])
    }
    
}




