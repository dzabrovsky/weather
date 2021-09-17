//
//  UICustomAlertCollectionViewCell.swift
//  Weather
//
//  Created by Denis Zabrovsky on 02.09.2021.
//

import UIKit

class UICustomAlertCollectionViewCell: UICollectionViewCell {
    
    private static let k: CGFloat = UIScreen.main.bounds.width / 375
    public let text: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Manrope-Medium", size: 14 * k)
        label.textColor = UIColor.init(named: "black_text")
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor =  UIColor.init(named: "cancel_button_background")
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        self.addSubview(text)
        text.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8).isActive = true
        text.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8).isActive = true
        text.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4).isActive = true
        text.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
