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
    
    func getCitiesFromFakeService(completion: @escaping (_ cities: [City]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let citiesFromService : [City] = JSONParser().parseCities()
            let citiesFromDatabase : [City] = self.getCitiesFromDatabase()
            
            citiesFromService.forEach { serviceCity in
                if citiesFromDatabase.contains(where: { city in
                    serviceCity.id == city.id
                }) {
                    self.updateCity(city: serviceCity)
                } else {
                    self.save(cityModel: serviceCity)
                }
            }
            
            citiesFromDatabase.forEach { databaseCity in
                guard citiesFromDatabase.contains(where: { city in
                    databaseCity.id == city.id
                }) else {
                    self.deleteCity(city: databaseCity)
                    return
                }
            }
            
            let context : NSManagedObjectContext = CoreDataManager.getInstance().managedObjectContext
            
            context.perform {
                do {
                    try context.save()
                } catch {
                    print("error: \(error as NSError)")
                }
                completion(citiesFromService)
            }
            
        }
    }
    
    func updateCity(city: City) {
        let context : NSManagedObjectContext = CoreDataManager.getInstance().managedObjectContext
        
        context.perform {
            let selectRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CITY")
            selectRequest.predicate = NSPredicate(format: "id = %d", city.id)
            
            do {
                let cityMO = try context.fetch(selectRequest).first as? CityMO
                
                cityMO?.name = city.name
                cityMO?.country = city.country
                cityMO?.lat = city.lat
                cityMO?.lon = city.lon

            } catch {
                print("error while updating cities \(error)")
            }
        }
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
            
            guard !result.isEmpty else {
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
    
    func deleteCity(city: City) {
        let context : NSManagedObjectContext = CoreDataManager.getInstance().managedObjectContext
        
        context.perform {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CITY")
            deleteFetch.predicate = NSPredicate(format: "id = %d", city.id)
            
            do {
                if let cityMO = try context.fetch(deleteFetch).first as? CityMO {
                    context.delete(cityMO)
                    try context.save()
                    print("deleting city")
                }
            } catch {
                print("error while updating cities")
            }
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
