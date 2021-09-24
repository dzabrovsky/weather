//
//  ThemeManager.swift
//  Weather
//
//  Created by Denis Zabrovsky on 15.09.2021.
//

import UIKit

class ThemeManager {
    
    static func switchTheme(sender: UIViewController){
        
        let isLight = UserDefaults.standard.bool(forKey: "WeatherApp_isLightThemeEnabled")
        
        if #available(iOS 13, *) {
            
            if isLight {
                sender.view.window?.overrideUserInterfaceStyle = .light
            }else{
                sender.view.window?.overrideUserInterfaceStyle = .dark
            }
            UIView.animate(withDuration: 0.3){
                sender.view.layoutIfNeeded()
            }
        }else{
            
            let alert = UIAlertController(title: "Темная тема не доступна!", message: "Данная опция доступна только для версии iOS 13 и выше", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
            alert.addAction(okButton)
            
            sender.present(alert, animated: true, completion: nil)
        }
        
        UserDefaults.standard.set(!isLight, forKey: "WeatherApp_isLightThemeEnabled")
    }
    
    static func setLastTheme(sender: UIViewController){
        
        let isLight = UserDefaults.standard.bool(forKey: "WeatherApp_isLightThemeEnabled")
        
        if #available(iOS 13, *) {
            
            if isLight {
                sender.view.window?.overrideUserInterfaceStyle = .light
            }else{
                sender.view.window?.overrideUserInterfaceStyle = .dark
            }
        }
    }
}
