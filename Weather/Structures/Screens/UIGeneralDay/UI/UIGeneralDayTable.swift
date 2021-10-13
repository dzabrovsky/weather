//
//  UIGeneralDayTable.swift
//  Weather
//
//  Created by Denis Zabrovsky on 01.09.2021.
//

import UIKit

fileprivate let k: CGFloat = UIScreen.main.bounds.width / 375

class UIGeneralDayTable: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        backgroundColor = UIColor.init(named: "background")
        refreshControl = UIRefreshControl()
        register(UIWeatherDayCell.self, forCellReuseIdentifier: "UIWeatherDayCell")
        register(UITodayWeatherCell.self, forCellReuseIdentifier: "UITodayWeatherCell")
        allowsMultipleSelection = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        separatorStyle = .none
        translatesAutoresizingMaskIntoConstraints = false
    }
}
