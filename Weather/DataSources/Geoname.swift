import UIKit

struct Geoname {
    let lat: Double
    let lon: Double
    let icon: UIImage
    let temperature: String
    let feelsLike: String
    
    init(lat: Double, lon: Double, icon: UIImage, temperature: String, feelsLike: String){
        self.lat = lat
        self.lon = lon
        self.icon = icon
        self.temperature = temperature
        self.feelsLike = feelsLike
    }
}
