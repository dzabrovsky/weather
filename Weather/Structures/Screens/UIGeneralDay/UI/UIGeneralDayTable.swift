//
//  UIGeneralDayTable.swift
//  Weather
//
//  Created by Denis Zabrovsky on 01.09.2021.
//

import UIKit

fileprivate let k: CGFloat = UIScreen.main.bounds.width / 375

class UIGeneralDayTable: UITableView {
    
    public func setup(){
        refreshControl = UIRefreshControl()
        register(UIWeatherDayCell.self, forCellReuseIdentifier: "UIWeatherDayCell")
        register(UITodayWeatherCell.self, forCellReuseIdentifier: "UITodayWeatherCell")
        allowsMultipleSelection = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.separatorStyle = .none
    }
}
