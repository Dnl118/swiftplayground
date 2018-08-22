//
//  WeatherPresenter.swift
//  testedanilo
//
//  Created by mosyle on 16/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import Foundation

struct WeatherPresenter {
    var dayWeathers : [Weather]
    
    var showDeatails : Bool
    
    init(dayWeathers: [Weather]) {
        self.dayWeathers = dayWeathers
        self.showDeatails = false
        
//        print("Weather size: \(dayWeathers.count)")
    }
    
    func getTextDate() -> String {
        return "\(dayWeathers[0].dateText ?? "")"
    }
    
    func getMaxTemp() -> String {
        var max : Double = 0
        
        for weather in dayWeathers {
            if (weather.max > max) {
                max = weather.max
            }
        }
        
        return "Max: \(max) F"
    }
    
    func getMinTemp() -> String {
        var min : Double = 0
        
        for weather in dayWeathers {
            if (weather.min > min) {
                min = weather.min
            }
        }

        return "Min: \(min) F"
    }
    
    func getEarlyWeather() -> String {
        return "Early -> Min: \(dayWeathers[0].min)F | Max: \(dayWeathers[0].max)F"
    }
    
    func getMorningWeather() -> String {
        if dayWeathers.count > 2 {
            return "Morning -> Min: \(dayWeathers[2].min)F | Max: \(dayWeathers[2].max)F"
        }
        return "Morning: - "
    }
    
    func getEveningWeather() -> String {
        if dayWeathers.count > 4 {
            return "Evening -> Min: \(dayWeathers[4].min)F | Max: \(dayWeathers[4].max)F"
        }
        return "Evening: - "
    }
    
    func getNightWeather() -> String {
        if dayWeathers.count > 6 {
            return "Night -> Min: \(dayWeathers[6].min)F | Max: \(dayWeathers[6].max)F"
        }
        return "Night: - "
    }
    
    func getPressure() -> String {
        return "Pressure: \(dayWeathers[0].pressure)"
    }
    
    func getHumidity() -> String {
        return "Humidity: \(dayWeathers[0].humidity)"
    }
    
}
