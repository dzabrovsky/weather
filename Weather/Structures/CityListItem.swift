import UIKit

struct CityListItem {
    var name: String = ""
    var lat: Double = 0
    var lon: Double = 0
    var lastUse: Date = Date()
    
    var icon: String = ""
    var temp: Float = 0
    var tempFeelsLike: Float = 0
    
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
