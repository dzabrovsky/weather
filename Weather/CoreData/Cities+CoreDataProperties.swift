//
//  Cities+CoreDataProperties.swift
//  Weather
//
//  Created by Denis Zabrovsky on 10.09.2021.
//
//

import Foundation
import CoreData


extension Cities {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cities> {
        return NSFetchRequest<Cities>(entityName: "Cities")
    }

    @NSManaged public var name: String
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var lastUse: Date?

}

extension Cities : Identifiable {

}
