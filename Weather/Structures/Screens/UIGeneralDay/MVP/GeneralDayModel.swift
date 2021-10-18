import UIKit
import CoreLocation
import Alamofire

class GeneralDayModel: GeneralDayModelProtocol {
    
    private let alamofireFacade: AlamofireFacadeProtocol
    
    init(alamofireFacade: AlamofireFacadeProtocol) {
        self.alamofireFacade = alamofireFacade
    }
    
    func updateDataByLocation(lat: Double, lon: Double, completion: @escaping (ForecastCodable) -> Void, error: @escaping (AlamofireStatus) -> Void){
        alamofireFacade.getForecast(lat: lat, lon: lon, completion: completion, error: error)
    }
}
