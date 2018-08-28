//
//  ServicesProvider.swift
//  testedanilo
//
//  Created by mosyle on 15/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import Foundation

class WeatherService {
    
    let API_KEY : String = "e1ba7a2bb7e730f378fe3f13e93b90ee"
    
    var dataTask : URLSessionDataTask? = nil
    
    func getWeather(cityID: Int, completion: @escaping (_ success: Bool, _ weathers: [Weather]?) -> Void) {
        dataTask?.cancel()
        
        let defaultSession = URLSession(configuration: .default)
        
        if var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast") {
            urlComponents.query = "id=\(cityID)&APPID=\(API_KEY)"

            guard let url = urlComponents.url else { return }

            var success : Bool = false

            var resultData : Data? = nil

            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }

                if let error : Error = error {
                    print("ERROR")
                    print(error.localizedDescription)
                } else if let data : Data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {

                    print("SUCCESS: \(data)")

                    success = true
                    resultData = data

                }

                OperationQueue.main.addOperation {
                    completion(success, JSONParser().parseWeather(data: resultData))
                }
            }

            dataTask?.resume()
            defaultSession.finishTasksAndInvalidate()
        }
    }
    
}
