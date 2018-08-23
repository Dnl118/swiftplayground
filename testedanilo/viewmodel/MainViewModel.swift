//
//  MainTableViewControllerViewModel.swift
//  testedanilo
//
//  Created by mosyle on 16/08/18.
//  Copyright © 2018 mosyle. All rights reserved.
//

import Foundation
import CoreData

class MainViewModel {
    
    func getCitiesFromFakeService() -> [City] {
        return JSONParser().parseCities()
    }
    
    func save(cityModel: City) {
        let context : NSManagedObjectContext = CoreDataManager.getInstance().managedObjectContext
        
        context.perform({
            if let entity = NSEntityDescription.entity(forEntityName: "CITY", in: context) {
                
                let newCity = NSManagedObject(entity: entity, insertInto: context)
                
                newCity.setValue(cityModel.id, forKey: "id")
                newCity.setValue(cityModel.name, forKey: "name")
                newCity.setValue(cityModel.country, forKey: "country")
                newCity.setValue(cityModel.lat, forKey: "lat")
                newCity.setValue(cityModel.lon, forKey: "lon")
                
                do {
                    try context.save()
                    //                    print("City saved: \(cityModel.toString())")
                } catch {
                    print("Failed saving city: \(cityModel.toString())")
                }
            }
        })
    }
    
    func getCitiesFromDatabase() -> [City] {
        let context : NSManagedObjectContext = CoreDataManager.getInstance().managedObjectContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CITY")
        
        var resultCitiesArray : [City] = []
        
        do {
            let result = try context.fetch(request)
            
            guard result.isEmpty else {
                return resultCitiesArray
            }
            
            let citiesMO : [CityMO] = result.compactMap {
                guard let cityMO = $0 as? CityMO else {
                    return nil
                }
                return cityMO
            }
            
            resultCitiesArray = citiesMO.compactMap {
                let cityMO : CityMO = $0

                return City(id: Int(cityMO.id), name: cityMO.name ?? "", country: cityMO.country ?? "", lat: cityMO.lat, lon: cityMO.lon)
            }
            
        } catch {
            print("Erro while selecting cities from database.")
        }
        
        return resultCitiesArray
    }
    
    func save(citiesModel : [City]){
        print("\n=================== Saving Cities ====================")
        for city in citiesModel {
            save(cityModel: city)
        }
    }
    
    func deleteAll() {
        let context : NSManagedObjectContext = CoreDataManager.getInstance().managedObjectContext
        
        context.perform({
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CITY")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
                print("\n================ Deleting all cities =================\n")
            } catch {
                print ("There was an error deleting all cities")
            }
        })
    }
    
}
