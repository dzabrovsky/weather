import UIKit

protocol CityListItemDataSourceProtocol {
    func getCityList() -> [CityListItem]
    func getCityListByIndexInArray(_ index: Int) -> CityListItem
}
class CityListItemDataSource: CityListItemDataSourceProtocol {
    var data: [CityListItem] = []
    
    func getCityList() -> [CityListItem] {
        return data
    }
    func getCityListByIndexInArray(_ index: Int) -> CityListItem {
        return data[index]
    }
}

struct CityListItem {
    var name: String
    var lat: Double
    var lon: Double
    var lastUse: Date
    
    var icon: String
    var temp: Float
    var tempFeelsLike: Float
    
    init(name: String, lat: Double, lon: Double, lastUse: Date, icon: String, temp: Float, tempFeelsLike: Float) {
        self.name = name
        self.lat = lat
        self.lon = lon
        self.lastUse = lastUse
        
        self.icon = icon
        self.temp = temp
        self.tempFeelsLike = tempFeelsLike
    }
    init(){
        self.name = ""
        self.lat = 0
        self.lon = 0
        self.lastUse = Date()
        
        self.icon = ""
        self.temp = 0
        self.tempFeelsLike = 0
    }
}
