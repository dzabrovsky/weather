//
//  UIGeneralDayView.swift
//  Weather
//
//  Created by Denis Zabrovsky on 01.09.2021.
//

import UIKit

class UIGeneralDayView: UIView {
    
    private let adapter: GeneralDayForecastAdapter = GeneralDayForecastAdapter()
    private let delegateAdapter: GeneralDayDelegateAdapter = GeneralDayDelegateAdapter()
    
    let header = UIGeneralDayHeader()
    let tableView = UIGeneralDayTable()
    
    var todayView = UITodayWeatherCell()
    
    init(){
        super.init(frame: CGRect())
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        tableView.dataSource = adapter
        tableView.delegate = delegateAdapter
    }
    
    private func layout() {
        
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
    }
    
    func refreshData(_ data: Forecast) {
        adapter.setData(data)
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
    
    func onRowSelected(handler: @escaping (Int) -> ()){
        delegateAdapter.setDelegate(delegate: handler)
    }
}
