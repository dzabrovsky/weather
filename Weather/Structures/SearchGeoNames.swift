import Foundation

struct SearchGeoNames: Codable {
    let geonames: [SearchGeoName]
}

struct SearchGeoName: Codable {
    let toponymName: String
    let name: String
    let lat: String
    let lon: String
    let population: Int?

    enum CodingKeys: String, CodingKey {
        case toponymName = "toponymName"
        case name = "name"
        case lat = "lat"
        case lon = "lng"
        case population = "population"
    }
}

extension SearchGeoNames {
    func convertToStringArray() -> SearchResults {
        let sortedGeonames = geonames.sorted(by: { $0.population ?? 0 > $1.population ?? 0 })
        
        var results = [String]()
        
        guard geonames.count > 0 else { return SearchResults(totalResults: 0, results: []) }
        
        var i: Int = 0
        while results.count < 10 && sortedGeonames.count > i {
            if !results.contains(sortedGeonames[i].name) {
                results.append(sortedGeonames[i].name)
            }
            i += 1
        }
        
        return SearchResults(totalResults: results.count, results: results)
    }
}
