import UIKit

struct GeoNameDataSource {
    let lat: Double
    let lon: Double
    let icon: UIImage
    let temp: String
    let feelsLike: String
    
    init(lat: Double, lon: Double, icon: UIImage, temp: String, feelsLike: String){
        self.lat = lat
        self.lon = lon
        self.icon = icon
        self.temp = temp
        self.feelsLike = feelsLike
    }
}
