import Foundation

struct SearchGeoNames: Codable {
    let geonames: [SearchGeoName]
}

struct SearchGeoName: Codable {
    let population: Int?
    let name: String
    let lat: String
    let lon: String

    enum CodingKeys: String, CodingKey {
        case population = "population"
        case name = "name"
        case lat = "lat"
        case lon = "lng"
    }
}
