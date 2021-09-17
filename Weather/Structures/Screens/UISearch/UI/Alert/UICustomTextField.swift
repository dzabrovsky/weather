//
//  CustomTextField.swift
//  Weather
//
//  Created by Denis Zabrovsky on 31.08.2021.
//

import UIKit

class UICustomTextField: UITextField {
    
    let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "outline_search_black_48pt")
        imageView.tintColor = UIColor.init(named: "icon_tint")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(icon)
        icon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        icon.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6).isActive = true
        icon.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6).isActive = true
        icon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let padding = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 8)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}
