import UIKit

class GeoNamesAdapter {
    static func convertToDataSource(data: CityListItem) -> GeoNameDataSource{
        
        return GeoNameDataSource(
            lat: data.lat,
            lon: data.lon,
            icon: ImageManager.getIconByCode(data.icon),
            temp: String(Int(data.temp)) + "°",
            feelsLike: String(Int(data.tempFeelsLike)) + "°"
        )
    }
}
