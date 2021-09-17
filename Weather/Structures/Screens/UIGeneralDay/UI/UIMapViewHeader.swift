//
//  UIMapViewHeader.swift
//  Weather
//
//  Created by Denis Zabrovsky on 13.09.2021.
//

import UIKit

class UIMapViewHeader: UIHeader {
    
    let backButton: UIHeaderButton = {
        let headerButton = UIHeaderButton(4)
        headerButton.translatesAutoresizingMaskIntoConstraints = false
        headerButton.icon.image=#imageLiteral(resourceName: "outline_arrow_back_ios_black_48pt")
        headerButton.layer.cornerRadius = 8
        return headerButton
    }()
    
    let locationButton: UIHeaderButton = {
        let headerButton = UIHeaderButton(4)
        headerButton.translatesAutoresizingMaskIntoConstraints = false
        headerButton.icon.image=#imageLiteral(resourceName: "outline_place_black_48pt")
        headerButton.layer.cornerRadius = 8
        return headerButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        
        self.addSubview(backButton)
        self.addSubview(locationButton)
        
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            backButton.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            locationButton.heightAnchor.constraint(equalTo: backButton.heightAnchor),
            locationButton.widthAnchor.constraint(equalTo: backButton.widthAnchor),
            locationButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            locationButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
