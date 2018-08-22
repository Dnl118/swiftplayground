//
//  City.swift
//  testedanilo
//
//  Created by mosyle on 13/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import Foundation

struct City {
    
    let id: Int
    let name: String
    let country: String
    let lat: Double
    let lon: Double
    
    init(id: Int, name: String, country: String, lat: Double, lon: Double) {
        self.id = id
        self.name = name
        self.country = country
        self.lat = lat
        self.lon = lon
    }
    
    public func getNameAndCountry() -> String {
        return "\(name) - \(country)"
    }
    
    public func toString() -> String {
        return "\(id) - \(name) - \(country)"
    }
}
