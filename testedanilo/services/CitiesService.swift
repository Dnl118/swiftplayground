//
//  CitiesService.swift
//  testedanilo
//
//  Created by mosyle on 16/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import Foundation

class CitiesService {
    
    func getCitiesJSON() -> [Dictionary<String, Any>] {
        
        guard let path = Bundle.main.path(forResource: "citylist", ofType: "json"),
            let json = try? JSONSerialization.jsonObject(
                with: Data(contentsOf: URL(fileURLWithPath: path)),
                options: JSONSerialization.ReadingOptions()),
            let citiesArray = json as? [Dictionary<String, Any>]
            else {
                return []
        }
        
        return citiesArray
    }
    
}
