import Foundation

struct SearchGeoNames: Codable {
    let geonames: [SearchGeoName]
}

struct SearchGeoName: Codable {
    let toponymName: String
    let name: String
    let lat: String
    let lon: String

    enum CodingKeys: String, CodingKey {
        case toponymName = "toponymName"
        case name = "name"
        case lat = "lat"
        case lon = "lng"
    }
}
