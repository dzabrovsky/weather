//
//  CitiesOnMap.swift
//  Weather
//
//  Created by Denis Zabrovsky on 14.09.2021.
//

import Foundation
import Alamofire

class GeoNames: Codable {
    var geonames: [GeoName]?
}

struct GeoName: Codable {
    let lon: Double
    let name: String
    let lat: Double
    let population: Int
    
    enum CodingKeys: String, CodingKey {
        case lon = "lng"
        case name = "name"
        case lat = "lat"
        case population = "population"
    }
}
