//
//  Current.swift
//  Weather
//
//  Created by Denis Zabrovsky on 03.09.2021.
//

import Foundation

struct Current: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: MainDetails
    let name: String
}
