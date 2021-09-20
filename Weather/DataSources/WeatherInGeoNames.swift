import Foundation

protocol WeatherInGeoNamesProtocol {
    func getItem() -> CityListItem
    func getItemByLocation(lat: Double, lon: Double) -> CityListItem!
}

class WeatherInGeoNames: WeatherInGeoNamesProtocol {
    var data: [CityListItem] = []
    var removedData: [CityListItem] = []
    
    func getItem() -> CityListItem {
        removedData.append(data.removeFirst())
        return removedData.last!
    }
    func getItemByLocation(lat: Double, lon: Double) -> CityListItem! {
        let index = removedData.firstIndex(where: { Int($0.lat * 1000) == Int(lat * 1000) && Int($0.lon * 1000) == Int(lon * 1000) } )
        if let index = index {
            return removedData.remove(at: index)
        }else{
            return nil
        }
    }
}
