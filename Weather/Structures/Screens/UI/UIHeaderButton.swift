//
//  IndentedImageView.swift
//  Weather
//
//  Created by Denis Zabrovsky on 17.08.2021.
//

import UIKit

public class UIHeaderButton: UIButton{
    
    public let icon:UIImageView = UIImageView()
    public var padding:CGFloat = 0
    
    init(_ value: CGFloat) {
        super.init(frame: CGRect())
        self.padding = value
        
        layoutThis()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setPaddings(){
        
        self.icon.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -padding*2).isActive = true
        self.icon.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -padding*2).isActive = true
        
        //Set paddings of imageView here
        self.icon.topAnchor.constraint(equalTo: self.topAnchor, constant: padding).isActive = true
        self.icon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding).isActive = true
        self.icon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: padding).isActive = true
        self.icon.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -padding).isActive = true
        
    }
    
    private func layoutThis(){

        self.backgroundColor = UIColor.init(named: "icon_background")
        self.addSubview(icon)
        
        self.icon.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        self.icon.tintColor = UIColor.init(named: "icon_tint")
        self.icon.translatesAutoresizingMaskIntoConstraints = false
        
        setPaddings()
    }
    
}
