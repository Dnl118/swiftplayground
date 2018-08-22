//
//  Weather.swift
//  testedanilo
//
//  Created by mosyle on 14/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import Foundation

struct Weather {
    
    let date : Date
    let dateText : String?
    let max : Double
    let min : Double
    let humidity : Int
    let pressure : Double
    
    init(date : Date, dateText: String?, max: Double, min : Double, humidity: Int, pressure : Double) {
        self.date = date
        self.dateText = dateText
        self.max = max
        self.min = min
        self.humidity = humidity
        self.pressure = pressure
    }
    
}
