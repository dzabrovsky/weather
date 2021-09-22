import UIKit

class CityAdapter {
    
    static func convertToCity(from: CityListItem) -> CityDataSource {
        return CityDataSource(
            name: from.name,
            temp: String( Int( from.temp ) ) + "°",
            feelsLike: String( Int( from.tempFeelsLike ) ) + "°",
            icon: ImageManager.getIconByCode( from.icon )
        )
    }
}
