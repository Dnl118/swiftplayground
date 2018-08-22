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
    
    func getCities() -> [City] {
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
                
                do {
                    try context.save()
                    print("City saved: \(cityModel.toString())")
                } catch {
                    print("Failed saving city: \(cityModel.toString())")
                }
            }
        })
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
