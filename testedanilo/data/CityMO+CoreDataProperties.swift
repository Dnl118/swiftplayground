//
//  CityMO+CoreDataProperties.swift
//  testedanilo
//
//  Created by mosyle on 23/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//
//

import Foundation
import CoreData


extension CityMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityMO> {
        return NSFetchRequest<CityMO>(entityName: "CITY")
    }

    @NSManaged public var country: String?
    @NSManaged public var id: Int32
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var name: String?
    @NSManaged public var weathers: NSSet?

}

// MARK: Generated accessors for weathers
extension CityMO {

    @objc(addWeathersObject:)
    @NSManaged public func addToWeathers(_ value: WeatherMO)

    @objc(removeWeathersObject:)
    @NSManaged public func removeFromWeathers(_ value: WeatherMO)

    @objc(addWeathers:)
    @NSManaged public func addToWeathers(_ values: NSSet)

    @objc(removeWeathers:)
    @NSManaged public func removeFromWeathers(_ values: NSSet)

}
