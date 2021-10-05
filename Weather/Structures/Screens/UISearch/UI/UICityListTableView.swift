//
//  UICityListTableView.swift
//  Weather
//
//  Created by Denis Zabrovsky on 03.09.2021.
//

import UIKit

class UICityListTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        self.backgroundColor = .clear
        register(UICityListTableViewCell.self, forCellReuseIdentifier: "UICityListTableViewCell")
        self.allowsSelection = true
        self.allowsSelectionDuringEditing = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.separatorStyle = .none
    }

}
