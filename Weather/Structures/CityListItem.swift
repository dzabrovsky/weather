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
        
    }
}

extension CityListItem {
    func convertToGeonames() -> GeonameDataSource{
        return GeonameDataSource(
            lat: self.lat,
            lon: self.lon,
            icon: ImageManager.getIconByCode(self.icon),
            temp: String(Int(self.temp)) + "°",
            feelsLike: String(Int(self.tempFeelsLike)) + "°"
        )
    }
    
    func convertToCity() -> CityDataSource {
        return CityDataSource(
            name: self.name,
            temp: String( Int( self.temp ) ) + "°",
            feelsLike: String( Int( self.tempFeelsLike ) ) + "°",
            icon: ImageManager.getIconByCode( self.icon )
        )
    }
}
