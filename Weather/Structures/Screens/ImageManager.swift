//
//  ImageManager.swift
//  Weather
//
//  Created by Denis Zabrovsky on 13.09.2021.
//

import UIKit

class ImageManager {
    
    private static func getImageSetByName(_ code: String) -> [UIImage] {
        var imageSet: [UIImage] = []
        for i in 0...30 {
            if i < 10 {
                if let image = UIImage.init(named: code + "_" + String(i)) {
                    imageSet.append(image)
                }
            }else{
                if let image = UIImage.init(named: code + "_" + String(i)) {
                    imageSet.append(image)
                }
            }
        }
        return imageSet
    }
    
    static func getIconAnimateByCode(_ code: String) -> [UIImage] {
        
        switch code {
        case "02d","02n", "04d","04n":
            return getImageSetByName("02d")
        case "03d","03n":
            return [#imageLiteral(resourceName: "03d")]
        case "09d","09n", "10d","10n":
            return getImageSetByName("09d")
        case "11d","11n":
            return getImageSetByName("11d")
        default:
            return [#imageLiteral(resourceName: "01d")]
        }
    }
    
    static func getIconByCode(_ code:String) -> UIImage{
        
        switch code {
        case "01d","01n":
            return #imageLiteral(resourceName: "01d")
        case "02d","02n":
            return #imageLiteral(resourceName: "02d")
        case "03d","03n":
            return #imageLiteral(resourceName: "03d")
        case "04d","04n":
            return #imageLiteral(resourceName: "02d")
        case "09d","09n":
            return #imageLiteral(resourceName: "09d")
        case "10d","10n":
            return #imageLiteral(resourceName: "09d")
        case "11d","11n":
            return #imageLiteral(resourceName: "11d")
        default:
            return #imageLiteral(resourceName: "01d")
        }
    }
}
