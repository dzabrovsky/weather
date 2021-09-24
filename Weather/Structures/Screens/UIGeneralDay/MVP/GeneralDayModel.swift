import UIKit
import CoreLocation
import Alamofire

class GeneralDayModel: Model {
    
    func updateDataByLocation(lat: Double, lon: Double, completion: @escaping (Forecast) -> Void){
        
        guard let url = URL(string: ("https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(APIKey)&lang=\(lang)&units=\(units)").encodeUrl) else {
            print("Cannot covert string to URL")
            return
        }
        
        getDataFromAPI(url){ result in
            completion(result)
        }
    }

    func updateDataByCityName(_ cityName: String, completion: @escaping (Forecast) -> Void) {
        
        guard let url = URL(string: ("https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=\(APIKey)&lang=\(lang)&units=\(units)").encodeUrl) else {
            print("Cannot covert string to URL")
            return
        }
        
        getDataFromAPI(url){ result in
            completion(result)
        }
    }
}
