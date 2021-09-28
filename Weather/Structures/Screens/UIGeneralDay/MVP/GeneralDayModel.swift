import UIKit
import CoreLocation
import Alamofire

class GeneralDayModel {
    
    private let alamofireFacade = AlamofireFacade.shared
    
    func updateDataByLocation(lat: Double, lon: Double, completion: @escaping (Forecast) -> Void){
        alamofireFacade.getForecast(lat: lat, lon: lon){ result in
            completion(result)
        }
    }

    func updateDataByCityName(_ cityName: String, completion: @escaping (Forecast) -> Void) {
        
        alamofireFacade.getForecast(cityName){ result in
            completion(result)
        }
    }
}
