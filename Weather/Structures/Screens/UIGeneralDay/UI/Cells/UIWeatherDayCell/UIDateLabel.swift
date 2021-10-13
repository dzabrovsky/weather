//
//  UIDateLabel.swift
//  Weather
//
//  Created by Denis Zabrovsky on 13.10.2021.
//

import UIKit

class UIDateLabel: UILabel {
    init(){
        super.init(frame: CGRect())
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont.init(name: "Manrope-Medium", size: 14 * screenScale )
        self.textAlignment = .center
        self.textColor = .white
    }
}
