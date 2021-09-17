//
//  GeneralDayTodayViewController.swift
//  Weather
//
//  Created by Denis Zabrovsky on 01.09.2021.
//

import UIKit

class GeneralDayTodayViewController: UIViewController {

    private var presenter: WeatherPresenterProtocol!
    
    private let headerView: Header = {
        let view = Header()
        view.translatesAutoresizingMaskIntoConstraints = false
    
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI(){
        
        view.addSubview(headerView)
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        headerView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 64/375).isActive = true
        
    }

}
