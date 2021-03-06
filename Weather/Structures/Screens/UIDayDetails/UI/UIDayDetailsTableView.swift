//
//  UIDayDetailsTableView.swift
//  Weather
//
//  Created by Denis Zabrovsky on 06.09.2021.
//

import UIKit

class UIDayDetailsTableView: UITableView {
    
    func setup() {
        
        self.separatorStyle = .none
        self.backgroundColor = UIColor.init(named: "background")
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.register(UIDetails.self, forCellReuseIdentifier: "UIDetails")
        self.register(UIChart.self, forCellReuseIdentifier: "UIChart")
        self.allowsSelection = false
    }
}
