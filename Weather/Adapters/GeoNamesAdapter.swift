import UIKit

class GeonamesAdapter {
    static func convertToGeonames(data: CityListItem) -> GeonameDataSource{
        
        return GeonameDataSource(
            lat: data.lat,
            lon: data.lon,
            icon: ImageManager.getIconByCode(data.icon),
            temp: String(Int(data.temp)) + "°",
            feelsLike: String(Int(data.tempFeelsLike)) + "°"
        )
    }
}
