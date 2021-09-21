// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let topLevel = try? newJSONDecoder().decode(APIData.self, from: jsonData)

import UIKit
import CoreLocation
import Alamofire

protocol GeneralDayPresenterProtocolForModel: AnyObject {
    
    func didDataUpdated(_ data: WeatherData)
    
}

class GeneralDayModel: Model {
    
    unowned var presenter: GeneralDayPresenterProtocolForModel!

    func didDataUpdated(_ data: WeatherData) {
        presenter.didDataUpdated(data)
    }
    
}

extension GeneralDayModel: GeneralDayModelProtocol {
    
    func updateDataByCityName() {
        
        guard let url = URL(string: ("https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=\(APIKey)&lang=\(lang)&units=\(units)").encodeUrl) else {
            print("Cannot covert string to URL")
            return
        }
        
        getDataFromAPI(url){ result in
            DispatchQueue.main.async {
                self.didDataUpdated(result)
            }
        }
    }
    
    
    func updateDataByLocation(lat: Double, lon: Double){
        
        guard let url = URL(string: ("https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(APIKey)&lang=\(lang)&units=\(units)").encodeUrl) else {
            print("Cannot covert string to URL")
            return
        }
        
        getDataFromAPI(url){ result in
            DispatchQueue.main.async {
                self.didDataByLocationUpdated(result)
            }
        }
    }
    

    }
}
