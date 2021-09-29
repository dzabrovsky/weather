//
//  Current.swift
//  Weather
//
//  Created by Denis Zabrovsky on 03.09.2021.
//

import Foundation

struct Current: Codable {
    let coord: CoordCodable
    let weather: [WeatherCodable]
    let main: MainDetailsCodable
    let name: String
}
