//
//  DayDetailsPresenter.swift
//  Weather
//
//  Created by Denis Zabrovsky on 06.09.2021.
//

import Foundation

protocol UIDayDetailsViewControllerProtocol: AnyObject {
    func updateView()
    func switchtheme()
}

class DayDetailsPresenter: DayDetailsPresenterProtocol {

    unowned var view: UIDayDetailsViewControllerProtocol!
    var model: GeneralDayModelProtocol!
    var router: RouterProtocol?
    
    func onTapBackButton() {
        router?.popToRoot()
    }
    
    func onTapThemeButton() {
        view.switchtheme()
    }
    
    func onTapCityListButton() {
        
    }
    
    func refreshData() {
        
    }
}
