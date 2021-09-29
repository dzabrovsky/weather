import UIKit
import CoreLocation
import Alamofire

class GeneralDayModel: GeneralDayModelProtocol {
    
    private let alamofireFacade = AlamofireFacade.shared
    
    func updateDataByLocation(lat: Double, lon: Double, completion: @escaping (ForecastCodable) -> Void){
        alamofireFacade.getForecast(lat: lat, lon: lon){ result in
            completion(result)
        }
    }

    func updateDataByCityName(_ cityName: String, completion: @escaping (ForecastCodable) -> Void) {
        
        alamofireFacade.getForecast(cityName){ result in
            completion(result)
        }
    }
}
