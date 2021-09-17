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

protocol WeatherInGeoNamesProtocol {
    func getItem() -> CityListItem
    func getItemByLocation(lat: Double, lon: Double) -> CityListItem!
}

class WeatherInGeoNames: WeatherInGeoNamesProtocol {
    var data: [CityListItem] = []
    var removedData: [CityListItem] = []
    
    func getItem() -> CityListItem {
        removedData.append(data.removeFirst())
        return removedData.last!
    }
    func getItemByLocation(lat: Double, lon: Double) -> CityListItem! {
        let index = removedData.firstIndex(where: { Int($0.lat * 1000) == Int(lat * 1000) && Int($0.lon * 1000) == Int(lon * 1000) } )
        if let index = index {
            return removedData.remove(at: index)
        }else{
            return nil
        }
    }
}
