//
//  WeatherCellTableViewCell.swift
//  Weather
//
//  Created by Denis Zabrovsky on 24.08.2021.
//

import UIKit

public class UIWeatherCell: UITableViewCell {
    
    var isSetuped: Bool = false
    
    func setupCell(){
        
    }
    
    func refresh(_ dataSource: DataSourceDay){
        print("Cell refreshed")
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool){
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
}
