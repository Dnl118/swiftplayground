//
//  WeatherTableViewModel.swift
//  testedanilo
//
//  Created by mosyle on 16/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import Foundation
import CoreData

class WeatherTableViewModel {
    
    let weatherService = WeatherService()
    
    func getWeathersFromService(cityID: Int, completion: @escaping (_ weathers: [WeatherPresenter]) -> Void) {
        
        weatherService.getWeather(cityID: cityID, completion: { success, array in
            
            guard success,
                let notOptionalArray : [Weather] = array else {
                    self.deleteAll(cityID: cityID)
                    return
            }
            
            self.deleteAll(cityID: cityID)
            self.save(weathersModel: notOptionalArray, cityID: cityID)
            
            let weatherPresenterArray : [WeatherPresenter] = self.weatherToWeatherPresenter(weathers: array)
            
            completion(weatherPresenterArray)
        })
        
    }
    
    func weatherToWeatherPresenter(weathers : [Weather]?) -> [WeatherPresenter] {
        var weatherPresenterArray : [WeatherPresenter] = []
        
        if let weatherArray : [Weather] = weathers, !weatherArray.isEmpty {
            var weatherArrayForSameDay : [Weather] = []
            var weatherAux : Weather = weatherArray[0]
            
            for weather in weatherArray {
                //                print("weatherAux.date: \(weatherAux.date) | weather.date: \(weather.date)")
                if (Calendar.current.isDate(weatherAux.date, inSameDayAs: weather.date)) {
                    weatherArrayForSameDay.append(weather)
                } else {
                    weatherPresenterArray.append(WeatherPresenter(dayWeathers: weatherArrayForSameDay))
                    
                    weatherArrayForSameDay = []
                    weatherAux = weather
                    weatherArrayForSameDay.append(weather)
                    
                    //                    print("weather: \(weatherArrayForSameDay.count)")
                }
            }
        }
        
        return weatherPresenterArray
    }
    
    func save(weatherModel: Weather, cityID: Int) {
        let context : NSManagedObjectContext = CoreDataManager.getInstance().managedObjectContext
        
        context.perform({
            if let entity = NSEntityDescription.entity(forEntityName: "WEATHER", in: context) {
                
                let newWeather = NSManagedObject(entity: entity, insertInto: context)
                
                newWeather.setValue(weatherModel.date, forKey: "date")
                newWeather.setValue(weatherModel.dateText, forKey: "date_text")
                newWeather.setValue(weatherModel.max, forKey: "temp_max")
                newWeather.setValue(weatherModel.min, forKey: "temp_min")
                newWeather.setValue(weatherModel.humidity, forKey: "humidity")
                newWeather.setValue(weatherModel.pressure, forKey: "pressure")
                newWeather.setValue(self.selectSynchronous(cityID: cityID), forKey: "city")
            }
        })
    }
    
    func save(weathersModel : [Weather], cityID: Int){
        print("\n=================== Saving Weathers ====================")
        for weather in weathersModel {
            save(weatherModel: weather, cityID: cityID)
        }
    }
    
    func deleteAll(cityID: Int) {
        print("\n================ Deleting weathers by city =================\n")
        
        let context : NSManagedObjectContext = CoreDataManager.getInstance().managedObjectContext
        
        context.perform {
            guard let cityMO : CityMO = self.selectSynchronous(cityID: cityID),
                let weathersMO = cityMO.weathers else {
                    return
            }
            
            let deletedWeathers = weathersMO.compactMap {
                if let weatherMO = $0 as? WeatherMO {
                    context.delete(weatherMO)
                    //                    print("deleted: \(weatherMO.date_text ?? "ERROR")")
                }
            }
            
            do {
                try context.save()
            } catch {
                print("Error while saving context")
            }
            
            //            print("deletedWeathers.count: \(deletedWeathers.count)")
        }
    }
    
    func selectAsynchronous(cityID: Int, completion: @escaping (_ success : Bool, _ cityMO : CityMO?) -> Void) {
        
        let context : NSManagedObjectContext = CoreDataManager.getInstance().managedObjectContext
        
        context.perform {
            let selectRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CITY")
            selectRequest.predicate = NSPredicate(format: "id = %d", cityID)
            
            let cityMO : CityMO? = nil
            do {
                if let cityMO = try context.fetch(selectRequest).first as? CityMO {
                    completion(true, cityMO)
                }
            } catch {
                completion(false, cityMO)
                print ("ERROR")
            }
        }
    }
    
    func selectSynchronous(cityID: Int) -> CityMO? {
        
        let context : NSManagedObjectContext = CoreDataManager.getInstance().managedObjectContext
        
        let selectRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CITY")
        selectRequest.predicate = NSPredicate(format: "id = %d", cityID)
        
        var cityMO : CityMO? = nil
        do {
            cityMO = try context.fetch(selectRequest).first as? CityMO
        } catch {
            print ("ERROR")
        }
        
        return cityMO
    }
    
    func getWeathersFromDatabase(cityID : Int, completion: @escaping (_ weathers: [WeatherPresenter]) -> Void) {
        
        let context : NSManagedObjectContext = CoreDataManager.getInstance().managedObjectContext
        
        context.perform {
            guard let cityMO : CityMO = self.selectSynchronous(cityID: cityID),
                let weathersFromCity = cityMO.weathers else {
                    return
            }
            
            let weathersMO : [WeatherMO] = weathersFromCity.compactMap {
                
                guard let weatherMO = $0 as? WeatherMO else {
                    return nil
                }
                
                return weatherMO
            }
            
            var weathers : [Weather] = weathersMO.compactMap {
                let weatherMO : WeatherMO = $0
                
                guard let date : Date = weatherMO.date as Date? else {
                    return nil
                }
                
                return Weather(date: date, dateText: weatherMO.date_text, max: weatherMO.temp_max, min: weatherMO.temp_min, humidity: Int(weatherMO.humidity), pressure: Double(weatherMO.pressure))
            }
            
            weathers.sort(by: {
                $0.date.compare($1.date) == .orderedAscending
            })
            
            completion(self.weatherToWeatherPresenter(weathers: weathers))
        }
    }
    
}
