//
//  Header.swift
//  Weather
//
//  Created by Denis Zabrovsky on 01.09.2021.
//

import UIKit

class UIHeader: UIView {
    
    public let title: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont.init(name: "Manrope-ExtraBold", size: 20)
        label.textColor = UIColor.init(named: "black_text")
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHeader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHeader(){
        
        self.backgroundColor = UIColor.init(named: "background")
        
        self.addSubview(title)
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        title.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 279/375).isActive = true
        title.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 30/64).isActive = true
        
        for family: String in UIFont.familyNames
        {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
        
    }
}
