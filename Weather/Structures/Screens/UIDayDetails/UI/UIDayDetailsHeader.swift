//
//  UIDayDetailsHeader.swift
//  Weather
//
//  Created by Denis Zabrovsky on 06.09.2021.
//

import UIKit

class UIDayDetailsHeader: UIHeader {
    
    let backButton: UIHeaderButton = {
        let headerButton = UIHeaderButton(4)
        headerButton.translatesAutoresizingMaskIntoConstraints = false
        headerButton.icon.image=#imageLiteral(resourceName: "outline_arrow_back_ios_black_48pt")
        headerButton.layer.cornerRadius = 8
        return headerButton
    }()
    
    let themeButton: UIHeaderButton = {
        let headerButton = UIHeaderButton(4)
        headerButton.translatesAutoresizingMaskIntoConstraints = false
        headerButton.icon.image=#imageLiteral(resourceName: "outline_light_mode_black_48pt")
        headerButton.layer.cornerRadius = 8
        return headerButton
    }()
    
    let cityListButton: UIHeaderButton = {
        let headerButton = UIHeaderButton(4)
        headerButton.translatesAutoresizingMaskIntoConstraints = false
        headerButton.icon.image=#imageLiteral(resourceName: "outline_search_black_48pt")
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
        self.addSubview(themeButton)
        self.addSubview(cityListButton)
        
        backButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        backButton.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        cityListButton.heightAnchor.constraint(equalTo: backButton.heightAnchor).isActive = true
        cityListButton.widthAnchor.constraint(equalTo: backButton.widthAnchor).isActive = true
        cityListButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        cityListButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        themeButton.heightAnchor.constraint(equalTo: backButton.heightAnchor).isActive = true
        themeButton.widthAnchor.constraint(equalTo: backButton.widthAnchor).isActive = true
        themeButton.rightAnchor.constraint(equalTo: cityListButton.leftAnchor, constant: -16).isActive = true
        themeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
    }
}
