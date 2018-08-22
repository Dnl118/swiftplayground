//
//  WeatherMO+CoreDataProperties.swift
//  testedanilo
//
//  Created by mosyle on 17/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//
//

import Foundation
import CoreData


extension WeatherMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherMO> {
        return NSFetchRequest<WeatherMO>(entityName: "WEATHER")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var temp_max: Double
    @NSManaged public var date_text: String?
    @NSManaged public var temp_min: Double
    @NSManaged public var humidity: Int16
    @NSManaged public var pressure: Int32
    @NSManaged public var city: CityMO?

}
