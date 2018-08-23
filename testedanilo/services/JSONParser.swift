//
//  JsonParser.swift
//  testedanilo
//
//  Created by mosyle on 13/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import Foundation

class JSONParser {
    
    func parseCities() -> [City] {
        
        let cities: [City] = CitiesService().getCitiesJSON().prefix(10).compactMap {
            var currentCity : Dictionary<String, Any> = $0
            
            if let id : Int = currentCity["id"] as? Int,
                let name : String = currentCity["name"] as? String,
                let country : String = currentCity["country"] as? String,
                let coord : Dictionary<String, Any> = currentCity["coord"] as? Dictionary<String, Any>,
                let lat : Double = coord["lat"] as? Double,
                let lon : Double = coord["lon"] as? Double {
                
                return City(id: id, name: name, country: country, lat: lat, lon: lon)
            }
            
            return nil
        }
        
        return cities
    }
    
    func parseWeather(data: Data?) -> [Weather] {
        //        print("parsing weather")
        
        if data == nil { return [] }
        
        guard let notNullData : Data = data,
            let json = try? JSONSerialization.jsonObject(
                with: notNullData, options: JSONSerialization.ReadingOptions()),
            let weatherJSON = json as? Dictionary<String, Any>,
            let weatherList = weatherJSON["list"] as? [Dictionary<String, Any>]
            else {
                print("some parsing error")
                return []
        }
        
//                print(weatherList)
        
        let weatherArray : [Weather] = weatherList.compactMap {
            var currentWeather : Dictionary<String, Any> = $0
            
            var date : Date = Date()
            
            if let timestamp : Double = (currentWeather["dt"] as? Double) {
                date = Date(timeIntervalSince1970: timestamp)
            }
            
            let dateTxt : String? = currentWeather["dt_txt"] as? String
            
            if let mainInfo : Dictionary<String, Any> = currentWeather["main"] as? Dictionary<String, Any>,
                let tempMax : Double = mainInfo["temp_max"] as? Double,
                let tempMin : Double = mainInfo["temp_min"] as? Double,
                let humidity : Int = mainInfo["humidity"] as? Int,
                let pressure : Double = mainInfo["pressure"] as? Double {
                
                return Weather(date: date, dateText: dateTxt, max: tempMax, min: tempMin, humidity: humidity, pressure: pressure)
            }
            
            return nil
        }
        
        return weatherArray
    }
    
}
