//
//  UIGeneralDayView.swift
//  Weather
//
//  Created by Denis Zabrovsky on 01.09.2021.
//

import UIKit

class UIGeneralDayView: UIView {
    
    var presenter: GeneralDayPresenterProtocol
    
    //Actions
    @objc private func onTapOpenMapButton(sender: UIHeaderButton!){
        presenter.onTapOpenMapButton()
    }
    
    @objc private func onTapThemeButton(sender: UIHeaderButton!){
        presenter.onTapThemeButton()
    }
    
    @objc private func onTapCityListButton(sender: UIHeaderButton!){
        presenter.onTapCityListButton()
    }
    
    @objc private func pullToRefresh(sender: UIRefreshControl){
        presenter.updateDataByUser()
    }
    
    let header: UIGeneralDayHeader = {
        let header = UIGeneralDayHeader()
        header.title.text = "Тамбов"
        header.backgroundColor = UIColor.init(named: "background")
        header.translatesAutoresizingMaskIntoConstraints = false
        
        return header
    }()
    
    let tableView: UIGeneralDayTable = {
        let table = UIGeneralDayTable()
        table.setup()
        table.separatorStyle = .none
        table.backgroundColor = UIColor.init(named: "background")
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    var todayView = UITodayWeatherCell()
    
    init(presenter: GeneralDayPresenterProtocol){
        self.presenter = presenter
        super.init(frame: CGRect())
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        
        self.backgroundColor = UIColor.init(named: "background")
        
        self.addSubview(header)
        self.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            header.leftAnchor.constraint(equalTo: self.leftAnchor),
            header.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            header.rightAnchor.constraint(equalTo: self.rightAnchor),
            header.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 64/375),
            
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 4),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        setActions()
    }
    
    private func setActions(){
        
        header.themeButton.addTarget(self, action: #selector(onTapThemeButton), for: .touchDown)
        header.openMapButton.addTarget(self, action: #selector(onTapOpenMapButton(sender:)), for: .touchDown )
        header.cityListButton.addTarget(self, action: #selector(onTapCityListButton(sender:)), for: .touchDown)
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
    }
    
}
