import UIKit

struct CityListItem {
    var name: String = ""
    var lat: Double = 0
    var lon: Double = 0
    var index: Int = 0
    
    var icon: String = ""
    var temp: Float = 0
    var tempFeelsLike: Float = 0
    
    init(name: String, lat: Double, lon: Double, index: Int, icon: String, temp: Float, tempFeelsLike: Float) {
        self.name = name
        self.lat = lat
        self.lon = lon
        self.index = index
        
        self.icon = icon
        self.temp = temp
        self.tempFeelsLike = tempFeelsLike
    }
    init(){
        
    }
}

extension CityListItem {
    func convertToGeonames() -> Geoname{
        return Geoname(
            lat: self.lat,
            lon: self.lon,
            icon: ImageManager.getIconByCode(self.icon),
            temperature: String(Int(self.temp)) + "°",
            feelsLike: String(Int(self.tempFeelsLike)) + "°"
        )
    }
    
    func convertToCity() -> CityWeather {
        return CityWeather(
            name: self.name,
            temp: String( Int( self.temp ) ) + "°",
            feelsLike: String( Int( self.tempFeelsLike ) ) + "°",
            icon: ImageManager.getIconByCode( self.icon ),
            index: self.index
        )
    }
}
